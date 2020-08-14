locals {
  #GCP Variables
  gcp_region  = "australia-southeast1" # Region to deploy in
  gcp_bgp_asn = "65200"                # BGP ASN to Assign to Cloud Router

  #AWS Variables
  aws_region  = "ap-southeast-2"        #AWS Region to deploy in.
  aws_network = "vpc-d0b506b5"          # VPC to deploy to
  aws_bgp_asn = "65100"                 #BGP ASN to Assign to Interface
  aws_tgw_id  = "tgw-067fc30b039641df1" # Transit Gateway ID to associate the VPN Gateway

}

module "gcp_aws_vpn_management" {
  source = ".//modules/vpn_aws_gcp"
  #Name Constructor Variables
  environment      = "mgt"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region       # Region to deploy in
  gcp_project = "barbados-mgmt-583929" # Project to deploy in
  gcp_network = "management-vpc"       # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn      # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  #AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn #BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
}

module "gcp_aws_vpn_development" {
  source           = ".//modules/vpn_aws_gcp"
  environment      = "dev"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region      # Region to deploy in
  gcp_project = "barbados-dev-583929" # Project to deploy in
  gcp_network = "development-vpc"     # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn     # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  #AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn #BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway

}

module "gcp_aws_vpn_staging" {
  source           = ".//modules/vpn_aws_gcp"
  environment      = "stg"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region        # Region to deploy in
  gcp_project = "barbados-stage-583929" # Project to deploy in
  gcp_network = "staging-vpc"           # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn       # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  #AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn #BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
}

module "gcp_aws_vpn_production" {
  source           = ".//modules/vpn_aws_gcp"
  environment      = "prd"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region       # Region to deploy in
  gcp_project = "barbados-prod-583929" # Project to deploy in
  gcp_network = "production-vpc"       # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn      # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  #AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn #BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
}

