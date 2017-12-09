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
  default = "devsecops-example-env"
}
