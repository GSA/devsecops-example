variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "database_subnet_cidrs" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ami_id" {
  default = "ami-cd0f5cb6"
  description = "Defaults to Ubuntu Server 16.04 LTS (HVM), SSD Volume Type for us-east-1"
}

variable "ip_whitelist" {
  default = "0.0.0.0/0"
}
