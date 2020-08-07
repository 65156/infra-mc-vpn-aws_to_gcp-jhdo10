locals {
  transit_gateway_id = "tgw-067fc30b039641df1"
}

resource "aws_customer_gateway" "cgw-gcp-au" {
  bgp_asn    = 65200
  ip_address = "10.61.7.250"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn-gcp-au-01" {
  customer_gateway_id = "${aws_customer_gateway.cgw-gcp-au.id}"
  transit_gateway_id  = local.transit_gateway_id
  type                = "ipsec.1"
  static_routes_only  = false
}


