locals {
  transit_gateway_id = "tgw-067fc30b039641df1"
  aws_subnet_id      = "subnet-5136a434"
  aws_vpc_id         = "vpc-d0b506b5"
}

/*
 * Terraform compute resources for AWS.
 */

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_disk_image]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "aws-ip" {
  vpc = true

  instance                  = aws_instance.aws-vm.id
  associate_with_private_ip = var.aws_vm_address
}

resource "aws_instance" "aws-vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.aws_instance_type
  subnet_id     = local.aws_subnet_id
  key_name      = "vm-ssh-key"

  associate_public_ip_address = true
  private_ip                  = var.aws_vm_address

  vpc_security_group_ids = [
    aws_security_group.aws-allow-icmp.id,
    aws_security_group.aws-allow-ssh.id,
    aws_security_group.aws-allow-vpn.id,
    aws_security_group.aws-allow-internet.id,
  ]

  user_data = replace(
    replace(
      file("vm_userdata.sh"),
      "<EXT_IP>",
      google_compute_address.gcp-ip.address,
    ),
    "<INT_IP>",
    var.gcp_vm_address,
  )

  tags = {
    Name = "aws-vm-${var.global["aws_default_region"]}"
  }
}


resource "aws_customer_gateway" "cgw-gcp-au" {
  bgp_asn    = 65200
  ip_address = "10.61.7.250"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn-gcp-01" {
  customer_gateway_id = aws_customer_gateway.cgw-gcp-au.id
  transit_gateway_id  = local.transit_gateway_id
  type                = "ipsec.1"
  static_routes_only  = false
}


# Allow PING testing.
resource "aws_security_group" "aws-allow-icmp" {
  name        = "aws-allow-icmp"
  description = "Allow icmp access from anywhere"
  vpc_id      = local.aws_vpc_id

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow SSH for iperf testing.
resource "aws_security_group" "aws-allow-ssh" {
  name        = "aws-allow-ssh"
  description = "Allow ssh access from anywhere"
  vpc_id      = local.aws_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow traffic from the VPN subnets.
resource "aws_security_group" "aws-allow-vpn" {
  name        = "aws-allow-vpn"
  description = "Allow all traffic from vpn resources"
  vpc_id      = local.aws_vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.gcp_subnet1_cidr]
  }
}

# Allow TCP traffic from the Internet.
resource "aws_security_group" "aws-allow-internet" {
  name        = "aws-allow-internet"
  description = "Allow http traffic from the internet"
  vpc_id      = local.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

