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

/*
 * ----------VPN Connection----------
 */

resource "google_compute_address" "vpn-ip-au" {
  name   = "vpn-ip-au"
  region = var.global[gcp_default_region]
}

resource "google_compute_vpn_gateway" "vgw-aws-au" {
  name    = "vgw-aws-au"
  network = var.global[gcp_network]
  region  = var.global[gcp_default_region]
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn-ip-au.address
  target      = google_compute_vpn_gateway.vgw-aws-au.self_link
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500-500"
  ip_address  = google_compute_address.vpn-ip-au.address
  target      = google_compute_vpn_gateway.vgw-aws-au.self_link
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500-4500"
  ip_address  = google_compute_address.vpn-ip-au.address
  target      = google_compute_vpn_gateway.vgw-aws-au.self_link
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

  router = google_compute_router.gcp-router1.name

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_router" "gcp-router1" {
  name    = "gcp-router1"
  region  = var.global[gcp_default_region]
  network = var.global[gcp_network]
  bgp {
    asn = aws_customer_gateway.aws-cgw.bgp_asn
  }
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.2"

  name    = "example-router"
  project = "<PROJECT ID>"
  region  = "us-central1"
  network = "default"
}

resource "google_compute_router_peer" "gcp-router1-peer" {
  name            = "gcp-to-aws-bgp1"
  router          = google_compute_router.gcp-router1.name
  region          = google_compute_router.gcp-router1.region
  peer_ip_address = aws_vpn_connection.vpn-gcp-au-01.tunnel1_vgw_inside_address
  peer_asn        = var.GCP_TUN1_VPN_GW_ASN
  interface       = google_compute_router_interface.router_interface1.name
}

resource "google_compute_router_interface" "router_interface1" {
  name       = "gcp-to-aws-interface1"
  router     = google_compute_router.gcp-router1.name
  region     = google_compute_router.gcp-router1.region
  ip_range   = "${aws_vpn_connection.vpn-gcp-au-01.tunnel1_cgw_inside_address}/${var.GCP_TUN1_CUSTOMER_GW_INSIDE_NETWORK_CIDR}"
  vpn_tunnel = google_compute_vpn_tunnel.aws-au-01.name
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

  router = google_compute_router.gcp-router2.name

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_router" "gcp-router2" {
  name    = "gcp-router2"
  region  = var.global[gcp_default_region]
  network = var.global[gcp_network]
  bgp {
    asn = aws_customer_gateway.aws-cgw.bgp_asn
  }
}

resource "google_compute_router_peer" "gcp-router2-peer" {
  name            = "gcp-to-aws-bgp2"
  router          = google_compute_router.gcp-router2.name
  region          = google_compute_router.gcp-router2.region
  peer_ip_address = aws_vpn_connection.vpn-gcp-au-01.tunnel2_vgw_inside_address
  peer_asn        = var.GCP_TUN2_VPN_GW_ASN
  interface       = google_compute_router_interface.router_interface2.name
}

resource "google_compute_router_interface" "router_interface2" {
  name       = "gcp-to-aws-interface2"
  router     = google_compute_router.gcp-router2.name
  region     = google_compute_router.gcp-router2.region
  ip_range   = "${aws_vpn_connection.vpn-gcp-au-01.tunnel2_cgw_inside_address}/${var.GCP_TUN2_CUSTOMER_GW_INSIDE_NETWORK_CIDR}"
  vpn_tunnel = google_compute_vpn_tunnel.vpn-aws-au-b.name
}