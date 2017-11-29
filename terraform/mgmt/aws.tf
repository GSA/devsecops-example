provider "aws" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    bucket = "devsecops-example-mgmt"
    key = "terraform/mgmt.tfstate"
  }
}

data "aws_region" "current" {
  current = true
}
