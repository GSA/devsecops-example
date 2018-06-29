variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az" {
  default     = "a"
  description = "Availability zone to use within the specified region - pick from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe"
}

variable "env_backend_bucket_prefix" {
  default = "devsecops-example-env-"
}

variable "sns_general_availability_topic_name" {
  default = "devsecops-example-availability-alarms"
}

variable "general_availability_protocol" {
  default     = "email"
  description = "See '--protocol' options under https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html#options"
}

variable "general_availability_endpoint" {
  type        = "string"
  description = "The destination (such as an email address) to send the monitoring alerts to. More info under https://docs.aws.amazon.com/cli/latest/reference/sns/subscribe.html#options. Note that changing this value will require you to run a 'taint aws_sns_topic.sns_general_availability' before an 'apply'."
}

variable "s3_logging_bucket_name" {
  default = "devsecops-logging"
}

variable "kinesis_delivery_stream" {
  default = "devsecops-logging"
}

variable "ekk_kinesis_stream_name" {
  default = "devsecops-logging-ekk"
}

variable "deployer_username" {
  default     = "circleci-deployer"
  description = "Username for the AWS IAM user"
}
