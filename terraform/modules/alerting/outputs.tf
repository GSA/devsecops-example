output "sns_topic_arn" {
  value = "${aws_sns_topic.sns_general_availability.arn}"
}

output "sns_topic_id" {
  value = "${aws_sns_topic.sns_general_availability.id}"
}