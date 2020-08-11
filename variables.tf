variable "global" {
  type = map
  default = {
    "gcp_org_id"                  = "590092815251"
    "gcp_org_domain"              = "ofx.com"
    "gcp_default_project_id"      = "gcp-ofx-vpchost-management"
    "gcp_default_billing_account" = "01B3C9-539FEB-11B3F1"
    "gcp_default_region"          = "australia-southeast1"
    "gcp_default_resource_zone"   = "australia-southeast1-b"

    "aws_default_region" = "ap-southeast-2"
    "gcp_network"        = "gcp-ofx-vpchost-management-vpc"
  }
}

variable "AWS_BGP_ASN" {
  default = "65100"
}

variable "GCP_BGP_ASN" {
  default = "65200"
}



