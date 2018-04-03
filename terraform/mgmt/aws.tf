provider "aws" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    key = "terraform/mgmt.tfstate"
  }
}

data "aws_region" "current" {}
