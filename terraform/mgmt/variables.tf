variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az" {
  default = "a"
  description = "Availability zone to use within the specified region - pick from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "jenkins_instance_type" {
  default = "t2.micro"
}

variable "jenkins_iam_role_prefix" {
  default = "jenkins_role_"
}

variable "env_backend_bucket_prefix" {
  default = "devsecops-example-env-"
}

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

variable "high_cpu_jenkins_alarm_threshold" {
  description = "Percent CPU threshold for alarm on Jenkins instance"
  default = "80"
}

variable "high_memory_jenkins_alarm_threshold" {
  description = "Percent memory threshold for alarm on Jenkins instance"
  default = "80"
}

variable "high_disk_util_jenkins_alarm_threshold" {
  description = "Percent disk utilization threshold for alarm on Wordpress instance"
  default = "85"
}
