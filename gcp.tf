/*
*                                                                        #
*    ▄▄▄█████▓▓█████ ▄▄▄       ███▄ ▄███▓          ██▓ ▄████▄  ▓█████     #
*    ▓  ██▒ ▓▒▓█   ▀▒████▄    ▓██▒▀█▀ ██▒         ▓██▒▒██▀ ▀█  ▓█   ▀     #
*    ▒ ▓██░ ▒░▒███  ▒██  ▀█▄  ▓██    ▓██░         ▒██▒▒▓█    ▄ ▒███       #
*    ░ ▓██▓ ░ ▒▓█  ▄░██▄▄▄▄██ ▒██    ▒██          ░██░▒▓▓▄ ▄██▒▒▓█  ▄     #
*      ▒██▒ ░ ░▒████▒▓█   ▓██▒▒██▒   ░██▒         ░██░▒ ▓███▀ ░░▒████▒    #
*      ▒ ░░   ░░ ▒░ ░▒▒   ▓▒█░░ ▒░   ░  ░         ░▓  ░ ░▒ ▒  ░░░ ▒░ ░    #
*        ░     ░ ░  ░ ▒   ▒▒ ░░  ░      ░          ▒ ░  ░  ▒    ░ ░  ░    #
*      ░         ░    ░   ▒   ░      ░             ▒ ░░           ░       #
*                ░ OFX INFRASTRUCTURE & CLOUD ENGINEERING         ░  ░    #
*                                                                         #                                                        
*          
*.DESCRIPTION
*  <Maintains a cloud VPN connection between AWS and GCP>
*.INPUTS
*  <
*.OUTPUTS
*  <
*.NOTES
*  <Author: Fraser Elliot Carter Smith
*/

locals {
  gcp_subnetwork = "gcp-ofx-vpchost-management-private01-net-pxn17o"
}

/*
 * ----------Cloud Router----------
 */

resource "google_compute_router" "router-a" {
  name    = "router-a"
  region  = var.global["gcp_default_region"]
  network = var.global["gcp_network"]
  bgp {
    asn = aws_customer_gateway.cgw-gcp-au.bgp_asn
  }
}

resource "google_compute_router_peer" "router-a-peer" {
  name            = "gcp-to-aws-bgp-a"
  router          = google_compute_router.router-a.name
  region          = google_compute_router.router-a.region
  peer_ip_address = aws_vpn_connection.vpn-gcp-au-01.tunnel1_vgw_inside_address
  peer_asn        = var.GCP_TUN1_VPN_GW_ASN
  interface       = google_compute_router_interface.router_interface1.name
}

resource "google_compute_router_interface" "router_interface1" {
  name       = "gcp-to-aws-interface-a"
  router     = google_compute_router.router-a.name
  region     = google_compute_router.router-a.region
  ip_range   = "${aws_vpn_connection.vpn-gcp-au-01.tunnel1_cgw_inside_address}/${var.GCP_TUN1_CUSTOMER_GW_INSIDE_NETWORK_CIDR}"
  vpn_tunnel = google_compute_vpn_tunnel.vpn-aws-au-a.name
}

resource "google_compute_router" "router-b" {
  name    = "router-b"
  region  = var.global["gcp_default_region"]
  network = var.global["gcp_network"]
  bgp {
    asn = aws_customer_gateway.cgw-gcp-au.bgp_asn
  }
}

resource "google_compute_router_peer" "router-b-peer" {
  name            = "gcp-to-aws-bgp-b"
  router          = google_compute_router.router-b.name
  region          = google_compute_router.router-b.region
  peer_ip_address = aws_vpn_connection.vpn-gcp-au-01.tunnel2_vgw_inside_address
  peer_asn        = var.GCP_TUN2_VPN_GW_ASN
  interface       = google_compute_router_interface.router_interface2.name
}

resource "google_compute_router_interface" "router_interface2" {
  name       = "gcp-to-aws-interface-b"
  router     = google_compute_router.router-b.name
  region     = google_compute_router.router-b.region
  ip_range   = "${aws_vpn_connection.vpn-gcp-au-01.tunnel2_cgw_inside_address}/${var.GCP_TUN2_CUSTOMER_GW_INSIDE_NETWORK_CIDR}"
  vpn_tunnel = google_compute_vpn_tunnel.vpn-aws-au-b.name
}

/*
 * ----------VPN Tunnel1----------
 */

resource "google_compute_vpn_tunnel" "vpn-aws-au-a" {
  name          = "vpn-aws-au-a"
  peer_ip       = aws_vpn_connection.vpn-gcp-au-01.tunnel1_address
  shared_secret = aws_vpn_connection.vpn-gcp-au-01.tunnel1_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.vgw-aws-au.self_link

  router = google_compute_router.router-a.name

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

/*
 * ----------VPN Tunnel2----------
 */

resource "google_compute_vpn_tunnel" "vpn-aws-au-b" {
  name          = "vpn-aws-au-b"
  peer_ip       = aws_vpn_connection.vpn-gcp-au-01.tunnel2_address
  shared_secret = aws_vpn_connection.vpn-gcp-au-01.tunnel2_preshared_key
  ike_version   = 1

  target_vpn_gateway = google_compute_vpn_gateway.vgw-aws-au.self_link

  router = google_compute_router.router-b.name

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

