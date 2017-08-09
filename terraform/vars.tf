variable "ami_id" {
  default = "ami-cd0f5cb6"
  description = "Defaults to Ubuntu Server 16.04 LTS (HVM), SSD Volume Type for us-east-1"
}

variable "ip_whitelist" {
  default = "0.0.0.0/0"
}
