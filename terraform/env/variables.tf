variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["a", "b"]
  description = "Availability zones to use within the specified region - pick two from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#using-regions-availability-zones-describe"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "database_subnet_cidrs" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ip_whitelist" {
  default = "0.0.0.0/0"
}

variable "private_zone_name" {
  default = "devsecops.local"
}

variable "db_pass" {
  description = "The database password"
  type = "string"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "wordpress_iam_role_name" {
  default = "wordpress_role"
}

variable "sns_general_availability_topic_name" {
  default = "devsecops-example-availability-alarms"
}

variable "general_availability_email" {
  type = "string"
  description = "The email address to send the monitoring alerts to. Note that changing this value will require you to run a 'taint aws_sns_topic.sns_general_availability' before an 'apply'."
}
