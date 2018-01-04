output "env_backend_bucket" {
  value = "${aws_s3_bucket.env_backend.id}"
}
