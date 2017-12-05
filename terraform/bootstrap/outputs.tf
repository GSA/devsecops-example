output "bucket" {
  value = "${aws_s3_bucket.backend.id}"
}

output "sns_general_availability_topic_id" {
  value = "${aws_sns_topic.sns_general_availability.id}"
}

output "sns_general_availability_topic_arn" {
  value = "${aws_sns_topic.sns_general_availability.arn}"
}
