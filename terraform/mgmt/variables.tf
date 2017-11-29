variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "jenkins_instance_type" {
  default = "t2.micro"
}

variable "env_backend_bucket" {
  default = "devsecops-example-env"
}
