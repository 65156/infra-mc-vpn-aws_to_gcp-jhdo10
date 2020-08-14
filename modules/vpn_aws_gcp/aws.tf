
resource "aws_customer_gateway" "gateway_01" {
  bgp_asn    = var.gcp_bgp_asn
  ip_address = google_compute_address.vpn_ip.address

  type = "ipsec.1"
  tags = {
    "Name" = "cgw-gcp-${var.environment}-${var.region_shortname}"
  }
}

resource "aws_vpn_connection" "connection_01" {
  customer_gateway_id = aws_customer_gateway.gateway_01.id
  transit_gateway_id  = var.aws_tgw_id
  type                = "ipsec.1"
  static_routes_only  = false
  tags = {
    "Name" = "vpn-gcp-${var.environment}-${var.region_shortname}"
  }
}
