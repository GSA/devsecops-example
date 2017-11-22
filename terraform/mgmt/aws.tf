provider "aws" {
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    # TODO better strategy for backend uniqueness
    bucket = "devsecops-example-mgmt"
    key = "terraform/mgmt.tfstate"
  }
}

data "aws_region" "current" {
  current = true
}
