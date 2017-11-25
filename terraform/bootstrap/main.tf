provider "aws" {
  version = "~> 1.0"
}

resource "aws_s3_bucket" "backend" {
  bucket = "${var.bucket}"

  versioning {
    enabled = true
  }
}
