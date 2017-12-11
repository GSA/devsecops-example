variable "sns_general_availability_topic_name" {
  default = "devsecops-example-availability-alarms"
}

variable "general_availability_protocol" {
  default = "email"
  description = "See '--protocol' options under https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html#options"
}

variable "general_availability_endpoint" {
  type = "string"
  description = "The destination (such as an email address) to send the monitoring alerts to. More info under https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html#options. Note that changing this value will require you to run a 'taint aws_sns_topic.sns_general_availability' before an 'apply'."
}
