terraform {
  backend "gcs" {
    bucket = "terraform-statefiles-xjdfh3"
    prefix = "multicloud/vpn-aws-gcp"
  }
}

provider "google" {
  region = var.gcp_default_region
}

provider "aws" {
  region = var.aws_default_region
}

