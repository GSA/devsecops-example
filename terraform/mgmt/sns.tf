resource "aws_sns_topic" "sns_general_availability" {
  name = "${var.sns_general_availability_topic_name}"
}
