
                                                                         
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
Deploys Core VPN infrastructure to support cross cloud connectivity and office -> GCP connectivity.

This Project DOES NOT configure Route Tables within the context of VPC Networks in AWS so no traffic will traverse over these connections, for prodecural route updating, see repository [https://github.com/frasercarter/infra-aws-transit-gateway-zxc013 
](https://github.com/frasercarter/infra-aws-vpc-routing-lkj192)

## GCP Infrastructure
Multiple VPN Connections across multiple projects 
+ Cloud Router
+ HA VPN (2 Tunnels)
+ Public IP 

## AWS Infrastructure
Multiple VPN Connections (One per target GCP project) and associates with Transit Gateway.
+ Customer Gateway
+ VPN Connection (2 Tunnels)

## Topology

![Topology](https://raw.githubusercontent.com/frasercarter/infra-mc-vpn-aws_to_gcp-jhdo10/fraser/Network-VPN.jpg)

## Variables

   ### Name Construction Variables
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
