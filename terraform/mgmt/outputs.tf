output "sns_general_availability_topic_id" {
  value = "${aws_sns_topic.sns_general_availability.id}"
}

output "sns_general_availability_topic_arn" {
  value = "${aws_sns_topic.sns_general_availability.arn}"
}

output "jenkins_host" {
  value = "${aws_eip.jenkins.public_ip}"
}

output "env_backend_bucket" {
  value = "${aws_s3_bucket.env_backend.id}"
}
