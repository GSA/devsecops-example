output "jenkins_host" {
  value = "${aws_eip.jenkins.public_ip}"
}

output "env_backend_bucket" {
  value = "${aws_s3_bucket.env_backend.id}"
}
