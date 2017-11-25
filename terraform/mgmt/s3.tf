// need a different backend bucket from the mgmt one due to
// https://github.com/hashicorp/terraform/issues/15648
resource "aws_s3_bucket" "env_backend" {
  bucket = "${var.env_backend_bucket}"

  versioning {
    enabled = true
  }
}
