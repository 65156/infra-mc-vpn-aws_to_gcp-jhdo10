

locals {
  transit_gateway_id = "tgw-067fc30b039641df1"
  aws_subnet_id      = "subnet-5136a434"
  aws_vpc_id         = "vpc-d0b506b5"
}

resource "aws_customer_gateway" "cgw_gcp_au" {
  bgp_asn    = var.GCP_BGP_ASN
  ip_address = google_compute_address.ip_vpn_aws_au.address

  type = "ipsec.1"
  tags = {
    "Name" = "cgw-gcp-au"
  }
}

resource "aws_vpn_connection" "vpn_gcp_au" {
  customer_gateway_id = aws_customer_gateway.cgw_gcp_au.id
  transit_gateway_id  = local.transit_gateway_id
  type                = "ipsec.1"
  static_routes_only  = false
  tags = {
    "Name" = "vpn-gcp-au"
  }
}
