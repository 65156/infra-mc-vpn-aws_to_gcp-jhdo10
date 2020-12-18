
#Generic Variables (Used for constructing interface and service names)
variable "environment" {
  default = "dev"
}

variable "region_shortname" {
  default = "au"
}

#GCP Specific Variables
variable "gcp_region" {
  description = "region to deploy in"
  default     = "australia-southeast1"
}

variable "gcp_project" {
  description = "Project to deploy Cloud Router and HA VPN"
  default     = ""
}

variable "gcp_network" {
  description = "VPC Network to deploy Cloud Router and HA VPN"
  default     = ""
}

variable "gcp_bgp_asn" {
  description = "ASN of the GCP Router"
  default     = "65200"
}

#AWS Specific Variables
variable "aws_network" {
  description = "VPC to deploy the Customer Gateway and VPN"
  default     = "vpc-d0b506b5"
}

variable "aws_region" {
  description = "region to deploy in"
  default     = "ap-southeast-2"
}

variable "aws_bgp_asn" {
  description = "ASN of the AWS Router"
  default     = "65100"
}

variable "aws_tgw_id" {
  description = "Transit Gateway ID"
  default     = "tgw-067fc30b039641df1"
}

variable "gcp_default_region" {
  default = "australia-southeast1"
}

variable "aws_default_region" {
  default = "ap-southeast-2"
}

variable "custom_ranges" {
  type = list
  default = null
}
variable "advertise_mode" {
  default = "DEFAULT"
}