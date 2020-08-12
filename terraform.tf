terraform {
  backend "gcs" {
    bucket = "statefiles-tf-xjdfh2"
    prefix = "gcp/vpn"
  }
}

provider "google" {
  project = var.global["gcp_default_project_id"]
  region  = var.global["gcp_default_region"]
}

provider "aws" {
  region = var.global["aws_default_region"]
}

