provider "aws" {
  version = "~> 0.1"
}

terraform {
  backend "s3" {
    bucket = "devsecops-example"
    key = "terraform/terraform.tfstate"
  }
}

resource "aws_s3_bucket" "tf_remote_config_bucket" {
  # needs to match above
  bucket = "devsecops-example"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
}
