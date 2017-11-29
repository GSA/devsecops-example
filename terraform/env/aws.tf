provider "aws" {
  // https://github.com/terraform-providers/terraform-provider-aws/issues/1625
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    bucket = "devsecops-example-env"
    # TODO better strategy for backend uniqueness
    key = "terraform/env.tfstate"
  }
}

data "aws_region" "current" {
  current = true
}
