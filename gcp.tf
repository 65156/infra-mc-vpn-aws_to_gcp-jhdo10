
/*
 * ----------Cloud Router----------
 */

resource "google_compute_router" "cr_bgp_65200" {
  name    = "cr-bgp-65200"
  region  = var.global["gcp_default_region"]
  network = var.gcp_network
  bgp {
    asn = var.gcp_bgp_asn
  }
}

resource "google_compute_router_peer" "vpn_aws_au_peer_01" {
  name                      = "vpn-aws-au-peer-01"
  router                    = google_compute_router.cr_bgp_65200.name
  region                    = google_compute_router.cr_bgp_65200.region
  peer_ip_address           = aws_vpn_connection.vpn_gcp_au.tunnel1_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpn_aws_au_interface_01.name

}

resource "google_compute_router_peer" "vpn_aws_au_peer_02" {
  name                      = "vpn-aws-au-peer-02"
  router                    = google_compute_router.cr_bgp_65200.name
  region                    = google_compute_router.cr_bgp_65200.region
  peer_ip_address           = aws_vpn_connection.vpn_gcp_au.tunnel2_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 200
  interface                 = google_compute_router_interface.vpn_aws_au_interface_02.name

}

resource "google_compute_router_interface" "vpn_aws_au_interface_01" {
  name       = "vpn-aws-au-interface-01"
  router     = google_compute_router.cr_bgp_65200.name
  region     = google_compute_router.cr_bgp_65200.region
  ip_range   = "${aws_vpn_connection.vpn_gcp_au.tunnel1_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn_aws_au_tun_01.name
}

resource "google_compute_router_interface" "vpn_aws_au_interface_02" {
  name       = "vpn-aws-au-interface-02"
  router     = google_compute_router.cr_bgp_65200.name
  region     = google_compute_router.cr_bgp_65200.region
  ip_range   = "${aws_vpn_connection.vpn_gcp_au.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpn_aws_au_tun_02.name
}

/*
 * ----------VPN Tunnel----------
 */

resource "google_compute_address" "ip_vpn_aws_au" {
  name   = "ip-vpn-aws-au"
  region = var.global["gcp_default_region"]
}


resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.ip_vpn_aws_au.address
  target      = google_compute_vpn_gateway.vgw_aws_au.self_link
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = google_compute_address.ip_vpn_aws_au.address
  target      = google_compute_vpn_gateway.vgw_aws_au.self_link
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = google_compute_address.ip_vpn_aws_au.address
  target      = google_compute_vpn_gateway.vgw_aws_au.self_link
}

resource "google_compute_vpn_gateway" "vgw_aws_au" {
  name    = "vgw-aws-au"
  network = var.gcp_network
}

resource "google_compute_vpn_tunnel" "vpn_aws_au_tun_01" {
  name          = "vpn-aws-au-tunnel-01"
  peer_ip       = aws_vpn_connection.vpn_gcp_au.tunnel1_address
  shared_secret = aws_vpn_connection.vpn_gcp_au.tunnel1_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.vgw_aws_au.self_link

  router = google_compute_router.cr_bgp_65200.name
}

resource "google_compute_vpn_tunnel" "vpn_aws_au_tun_02" {
  name          = "vpn-aws-au-tunnel-02"
  peer_ip       = aws_vpn_connection.vpn_gcp_au.tunnel2_address
  shared_secret = aws_vpn_connection.vpn_gcp_au.tunnel2_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.vgw_aws_au.self_link

  router = google_compute_router.cr_bgp_65200.name

}

