provider "aws" {
  version = "~> 1.0"
}

resource "aws_s3_bucket" "backend" {
  bucket_prefix = "${var.bucket_prefix}"

  versioning {
    enabled = true
  }
}
