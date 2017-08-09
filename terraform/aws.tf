provider "aws" {
  version = "~> 0.1"
}

terraform {
  backend "s3" {
    bucket = "devsecops-example"
    key = "terraform/terraform.tfstate"
  }
}
