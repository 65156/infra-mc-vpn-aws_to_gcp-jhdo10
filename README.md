
                                                                         
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
Deploys Multiple HA VPN's in GCP (one per environment or project), AWS, and BGP Peering for ASN's 65100(aws), 65200(gcp).

# Variables

   ## Name Construction Variables
    Variables are used in the construction of names for services in both aws and gcp, these include the environment (in the case of gcp) and the region shortname (a short abbreviation or code for the region).

    ### Variable Inputs
    * environment 
    * region_shortname
    
    AWS
    Customer Gateway:
     cgw-gcp-${var.environment}-${var.region_shortname}

    Examples:
    "cgw-gcp-mgt-au"
    "cgw-gcp-dev-au"
    "cgw-gcp-prd-au"

    GCP
    VPN Interfaces, Tunnels etc:
    vpn-aws-${var.region_shortname}-tunnel-01

    Examples
    "vpn-aws-au-tunnel-01"
    "vpn-aws-au-interface-01"

## References

*   [GCP Cloud VPN Overview](https://cloud.google.com/compute/docs/vpn/overview)
*   [GCP Creating a VPN](https://cloud.google.com/compute/docs/vpn/creating-vpns)
*   [GCP VPN Interoperability Guides](https://cloud.google.com/compute/docs/vpn/interop-guides)
*   [GCP Creating a HA VPN](https://cloud.google.com/network-connectivity/docs/vpn/how-to/moving-to-ha-vpn)
*   [AWS VPN Connections](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpn-connections.html)
