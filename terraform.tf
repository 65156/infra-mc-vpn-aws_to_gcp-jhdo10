terraform {
  backend "gcs" {
    bucket = "ofx-infrastructure-tf-bkt"
    prefix = "multicloud-core"
  }
}

provider "google" {
  project = var.global["gcp_default_project_id"]
  region  = var.global["gcp_default_region"]
}

provider "aws" {
  region = var.global["aws_default_region"]
}

