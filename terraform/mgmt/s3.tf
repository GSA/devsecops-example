// need a different backend bucket from the mgmt one due to
// https://github.com/hashicorp/terraform/issues/15648
resource "aws_s3_bucket" "env_backend" {
  bucket_prefix = "${var.env_backend_bucket_prefix}"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "ssm_jenkins_patch_log_bucket" {
  bucket_prefix = "jenkins-patch-log-"
}