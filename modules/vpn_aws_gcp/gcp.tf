
/*
 * ----------Cloud Router----------
 */

resource "google_compute_router" "router_01" {
  name    = "cr-bgp-${var.gcp_bgp_asn}"
  region  = var.gcp_region
  network = var.gcp_network
  bgp {
    asn = var.gcp_bgp_asn
  }
}

resource "google_compute_router_peer" "peer_01" {
  name                      = "vpn-aws-${var.region_shortname}-peer-01"
  router                    = google_compute_router.router_01.name
  region                    = google_compute_router.router_01.region
  peer_ip_address           = aws_vpn_connection.connection_01.tunnel1_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.interface_01.name

}

resource "google_compute_router_peer" "peer_02" {
  name                      = "vpn-aws-${var.region_shortname}-peer-02"
  router                    = google_compute_router.router_01.name
  region                    = google_compute_router.router_01.region
  peer_ip_address           = aws_vpn_connection.connection_01.tunnel2_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 200
  interface                 = google_compute_router_interface.interface_02.name

}

resource "google_compute_router_interface" "interface_01" {
  name       = "vpn-aws-${var.region_shortname}-interface-01"
  router     = google_compute_router.router_01.name
  region     = google_compute_router.router_01.region
  ip_range   = "${aws_vpn_connection.connection_01.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_01.name
}

resource "google_compute_router_interface" "interface_02" {
  name       = "vpn-aws-${var.region_shortname}-interface-02"
  router     = google_compute_router.router_01.name
  region     = google_compute_router.router_01.region
  ip_range   = "${aws_vpn_connection.connection_01.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_02.name
}

/*
 * ----------VPN Tunnel----------
 */

resource "google_compute_address" "vpn_ip" {
  name   = "vpn-aws-${var.region_shortname}-ip"
  region = var.gcp_region
}


resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_vpn_gateway" "gateway_01" {
  name    = "vgw-aws-${var.region_shortname}"
  network = var.gcp_network
}

resource "google_compute_vpn_tunnel" "tunnel_01" {
  name          = "vpn-aws-${var.region_shortname}-tunnel-01"
  peer_ip       = aws_vpn_connection.connection_01.tunnel1_address
  shared_secret = aws_vpn_connection.connection_01.tunnel1_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gateway_01.self_link

  router = google_compute_router.router_01.name
}

resource "google_compute_vpn_tunnel" "tunnel_02" {
  name          = "vpn-aws-${var.region_shortname}-tunnel-01"
  peer_ip       = aws_vpn_connection.connection_01.tunnel2_address
  shared_secret = aws_vpn_connection.connection_01.tunnel2_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gateway_01.self_link

  router = google_compute_router.router_01.name

}

