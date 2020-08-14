
                                                                         
    ▄▄▄█████▓▓█████ ▄▄▄       ███▄ ▄███▓          ██▓ ▄████▄  ▓█████     
    ▓  ██▒ ▓▒▓█   ▀▒████▄    ▓██▒▀█▀ ██▒         ▓██▒▒██▀ ▀█  ▓█   ▀     
    ▒ ▓██░ ▒░▒███  ▒██  ▀█▄  ▓██    ▓██░         ▒██▒▒▓█    ▄ ▒███       
    ░ ▓██▓ ░ ▒▓█  ▄░██▄▄▄▄██ ▒██    ▒██          ░██░▒▓▓▄ ▄██▒▒▓█  ▄     
      ▒██▒ ░ ░▒████▒▓█   ▓██▒▒██▒   ░██▒         ░██░▒ ▓███▀ ░░▒████▒    
      ▒ ░░   ░░ ▒░ ░▒▒   ▓▒█░░ ▒░   ░  ░         ░▓  ░ ░▒ ▒  ░░░ ▒░ ░    
        ░     ░ ░  ░ ▒   ▒▒ ░░  ░      ░          ▒ ░  ░  ▒    ░ ░  ░    
      ░         ░    ░   ▒   ░      ░             ▒ ░░           ░       
                ░ OFX INFRASTRUCTURE & CLOUD ENGINEERING         ░  ░    
                                                                         
# Multicloud VPN - GCP-AWS VPN
Deploys a HA VPN in GCP, AWS, and BGP Peering for ASN's 65100(aws), 65200(gcp)

# Variables

   * Name Construction Variables
    environment and region_shortname are used in the construction of services in both aws and gcp example include"
    
    AWS
    Customer Gateway:
     cgw-gcp-${var.environment}-${var.region_shortname}

    Examples:
    "cgw-gcp-mgt-au"
    "cgw-gcp-dev-au"
    "cgw-gcp-prd-au"

    GCP
    VPN Connections, Tunnels etc:
    vpn-aws-${var.region_shortname}-tunnel-01

    Examples
    "vpn-aws-au-tunnel-01"
    "vpn-aws-au-interface-01"
  */

## References

*   [GCP Cloud VPN Overview](https://cloud.google.com/compute/docs/vpn/overview)
*   [GCP Creating a VPN](https://cloud.google.com/compute/docs/vpn/creating-vpns)
*   [GCP VPN Interoperability Guides](https://cloud.google.com/compute/docs/vpn/interop-guides)
*   [GCP Creating a HA VPN](https://cloud.google.com/network-connectivity/docs/vpn/how-to/moving-to-ha-vpn)
*   [AWS VPN Connections](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpn-connections.html)
