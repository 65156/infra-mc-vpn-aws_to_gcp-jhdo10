locals {
  #GCP Variables
  gcp_region  = "australia-southeast1" # Region to deploy in
  gcp_bgp_asn = "65200"                # BGP ASN to Assign to Cloud Router

  #AWS Variables
  aws_region  = "ap-southeast-2"        # AWS Region to deploy in.
  aws_network = "vpc-03293775381c130d4" # VPC to deploy to
  aws_bgp_asn = "65100"                 # BGP ASN to Assign to Interface
  aws_tgw_id  = "tgw-003078772a29d6bc6" # Transit Gateway ID to associate the VPN Gateway

}

module "mgt" {
  source = ".//modules/vpn_aws_gcp"
  providers = {
    google = google
    aws    = aws
  }
  #Name Constructor Variables
  environment      = "mgt"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region       # Region to deploy in
  gcp_project = "barbados-mgmt-583929" # Project to deploy in
  gcp_network = "management-vpc"       # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn      # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  # AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn # BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
  
  #custom routes
  advertise_mode = "CUSTOM" # CUSTOM or DYNAMIC
  custom_ranges  = ["35.199.192.0/19"] # Custom IP Ranges to advertise from GCP BGP Peer
}

module "dev" {
  source = ".//modules/vpn_aws_gcp"
  providers = {
    google = google
    aws    = aws
  }
  environment      = "dev"
  region_shortname = "au"

  #GCP Variables
  gcp_region  = local.gcp_region      # Region to deploy in
  gcp_project = "barbados-dev-583929" # Project to deploy in
  gcp_network = "development-vpc"     # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn     # BGP ASN to Assign to Cloud Router
  
  #AWS Variables
  aws_region  = local.aws_region  # AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn # BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway

}

module "stg" {
  source = ".//modules/vpn_aws_gcp"
  providers = {
    google = google
    aws    = aws
  }
  environment      = "stg"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region        # Region to deploy in
  gcp_project = "barbados-stage-583929" # Project to deploy in
  gcp_network = "staging-vpc"           # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn       # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  # AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn # BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
}

module "prd" {
  source = ".//modules/vpn_aws_gcp"
  providers = {
    google = google
    aws    = aws
  }
  environment      = "prd"
  region_shortname = "au"
  #GCP Variables
  gcp_region  = local.gcp_region       # Region to deploy in
  gcp_project = "barbados-prod-583929" # Project to deploy in
  gcp_network = "production-vpc"       # VPC to deploy to
  gcp_bgp_asn = local.gcp_bgp_asn      # BGP ASN to Assign to Cloud Router
  #AWS Variables
  aws_region  = local.aws_region  # AWS Region to deploy in.
  aws_network = local.aws_network # VPC to deploy to
  aws_bgp_asn = local.aws_bgp_asn # BGP ASN to Assign to Interface
  aws_tgw_id  = local.aws_tgw_id  # Transit Gateway ID to associate the VPN Gateway
}
