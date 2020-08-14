
module "gcp_aws_vpn_management" {
  source                       = ".//modules/vpn_aws_gcp"
  #Name Constructor Variables
  environment                  = "mgt"
  region_shortname             = "au" 
  #GCP Variables
  gcp_region                   = "australia-southeast1"
  gcp_network                  = "barbados-mgmt-583929"
  gcp_bgp_asn                  = "65200"
  #AWS Variables
  aws_region                   = "ap-southeast-2" #AWS Region to deploy in.
  aws_network                  = "vpc-d0b506b5" # VPC to deploy to
  aws_bgp_asn                  = "65100" #BGP ASN to Assign to Interface
  aws_tgw_id                   = "tgw-067fc30b039641df1" # Transit Gateway ID to associate the VPN Gateway
}

module "gcp_aws_vpn_development" {
  source                       = ".//modules/vpn_aws_gcp"
  environment                  = "dev"
  region_shortname             = "au"
  #GCP Variables
  gcp_region                   = "australia-southeast1"
  gcp_network                  = "barbados-dev-583929"
  gcp_bgp_asn                  = "65200"
  #AWS Variables
  aws_region                   = "ap-southeast-2" #AWS Region to deploy in.
  aws_network                  = "vpc-d0b506b5" # VPC to deploy to
  aws_bgp_asn                  = "65100" #BGP ASN to Assign to Interface
  aws_tgw_id                   = "tgw-067fc30b039641df1" # Transit Gateway ID to associate the VPN Gateway
}

module "gcp_aws_vpn_staging" {
  source                       = ".//modules/vpn_aws_gcp"
  environment                  = "stg"
  region_shortname             = "au"
  #GCP Variables
  gcp_region                   = "australia-southeast1"
  gcp_network                  = "barbados-stage-583929"
  gcp_bgp_asn                  = "65200"
  #AWS Variables
  aws_region                   = "ap-southeast-2" #AWS Region to deploy in.
  aws_network                  = "vpc-d0b506b5" # VPC to deploy to
  aws_bgp_asn                  = "65100" #BGP ASN to Assign to Interface
  aws_tgw_id                   = "tgw-067fc30b039641df1" # Transit Gateway ID to associate the VPN Gateway
}

module "gcp_aws_vpn_production" {
  source                       = ".//modules/vpn_aws_gcp"
  environment                  = "prd"
  region_shortname             = "au"
  #GCP Variables
  gcp_region                   = "australia-southeast1"
  gcp_network                  = "barbados-prod-583929"
  gcp_bgp_asn                  = "65200"
  #AWS Variables
  aws_region                   = "ap-southeast-2" #AWS Region to deploy in.
  aws_network                  = "vpc-d0b506b5" # VPC to deploy to
  aws_bgp_asn                  = "65100" #BGP ASN to Assign to Interface
  aws_tgw_id                   = "tgw-067fc30b039641df1" # Transit Gateway ID to associate the VPN Gateway
}

