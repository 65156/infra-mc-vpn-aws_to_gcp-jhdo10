
/*
 * ----------Cloud Router----------
 */
resource "google_compute_router" "router_01" {
  name    = "cr-bgp-${var.gcp_bgp_asn}"
  region  = var.gcp_region
  project = var.gcp_project
  network = var.gcp_network

  bgp {
    asn = var.gcp_bgp_asn
  }
}

resource "google_compute_router_peer" "peer" {
  count = 2
  name                      = "vpn-aws-${var.region_shortname}-peer-0${count.index + 1}"
  router                    = google_compute_router.router_01.name
  region                    = google_compute_router.router_01.region
  project                   = google_compute_router.router_01.project
  peer_ip_address           = "${count.index == 0 ? aws_vpn_connection.connection_01.tunnel1_vgw_inside_address : aws_vpn_connection.connection_01.tunnel2_vgw_inside_address}"
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = "${count.index == 0 ? 100 : 200}"
  interface                 = google_compute_router_interface.interface[count.index].name 
}
/*
resource "google_compute_router_peer" "peer_02" {
  name                      = "vpn-aws-${var.region_shortname}-peer-02"
  router                    = google_compute_router.router_01.name
  region                    = google_compute_router.router_01.region
  project                   = google_compute_router.router_01.project
  peer_ip_address           = aws_vpn_connection.connection_01.tunnel2_vgw_inside_address
  peer_asn                  = var.aws_bgp_asn
  advertised_route_priority = 200
  interface                 = google_compute_router_interface.interface_02.name

}
*/
resource "google_compute_router_interface" "interface" {
  count      = 2
  name       = "vpn-aws-${var.region_shortname}-interface-0${count.index + 1}"
  router     = google_compute_router.router_01.name
  region     = google_compute_router.router_01.region
  project    = google_compute_router.router_01.project
  ip_range   = "${count.index == 0 ? aws_vpn_connection.connection_01.tunnel1_cgw_inside_address : aws_vpn_connection.connection_01.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel[count.index].name
}

/*
resource "google_compute_router_interface" "interface_02" {
  name       = "vpn-aws-${var.region_shortname}-interface-02"
  router     = google_compute_router.router_01.name
  region     = google_compute_router.router_01.region
  project    = google_compute_router.router_01.project
  ip_range   = "${aws_vpn_connection.connection_01.tunnel2_cgw_inside_address}/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_02.name
}
*/
/*
 * ----------VPN Tunnel----------
 */

resource "google_compute_vpn_tunnel" "tunnel" {
  count         = 2
  name          = "vpn-aws-${var.region_shortname}-tunnel-0${count.index + 1}"
  region        = var.gcp_region
  project       = var.gcp_project
  peer_ip       = "${count.index == 0 ? aws_vpn_connection.connection_01.tunnel1_address : aws_vpn_connection.connection_01.tunnel2_address}"
  shared_secret = "${count.index == 0 ? aws_vpn_connection.connection_01.tunnel1_preshared_key : aws_vpn_connection.connection_01.tunnel2_preshared_key}"
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gateway_01.self_link

  router = google_compute_router.router_01.name
}
/*
resource "google_compute_vpn_tunnel" "tunnel_02" {
  name          = "vpn-aws-${var.region_shortname}-tunnel-01"
  region        = var.gcp_region
  project       = var.gcp_project
  peer_ip       = aws_vpn_connection.connection_01.tunnel2_address
  shared_secret = aws_vpn_connection.connection_01.tunnel2_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.gateway_01.self_link

  router = google_compute_router.router_01.name

}
*/
resource "google_compute_address" "vpn_ip" {
  name    = "vpn-aws-${var.region_shortname}-ip"
  region  = var.gcp_region
  project = var.gcp_project
}


resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  region      = var.gcp_region
  project     = var.gcp_project
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  region      = var.gcp_region
  project     = var.gcp_project
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  region      = var.gcp_region
  project     = var.gcp_project
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = google_compute_address.vpn_ip.address
  target      = google_compute_vpn_gateway.gateway_01.self_link
}

resource "google_compute_vpn_gateway" "gateway_01" {
  name    = "vgw-aws-${var.region_shortname}"
  network = var.gcp_network
  region  = var.gcp_region
  project = var.gcp_project
}


