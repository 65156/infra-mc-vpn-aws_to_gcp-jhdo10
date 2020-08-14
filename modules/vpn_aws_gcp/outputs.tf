output "aws_tunnel_ip_01" {
  value = aws_vpn_connection.connection_01.tunnel1_address
}

output "aws_tunnel_ip_02" {
  value = aws_vpn_connection.connection_01.tunnel2_address
}

output "gcp_vpn_ip" {
  value = google_compute_address.vpn_ip.address
}

