variable "global" {
  type = map
  default = {
    "gcp_org_id"                  = "590092815251"
    "gcp_org_domain"              = "ofx.com"
    "gcp_default_project_id"      = "gcp-ofx-vpchost-management"
    "gcp_default_billing_account" = "01B3C9-539FEB-11B3F1"
    "gcp_default_region"          = "australia-southeast1"
    "gcp_default_resource_zone"   = "australia-southeast1-b"
    "aws_default_region"          = "ap-southeast-2"
  }
}

variable "aws_bgp_asn" {
  description = "ASN of the AWS Router"
  default     = "65100"
}

variable "gcp_bgp_asn" {
  description = "ASN of the GCP Router"
  default     = "65200"
}

variable "gcp_network" {
  description = "VPC to deploy Cloud Router and HA VPN"
  default     = ""
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  default     = "tgw-067fc30b039641df1"
}

variable "aws_network" {
  description = "VPC to deploy the Customer Gateway and VPN"
  default     = "vpc-d0b506b5"
}        