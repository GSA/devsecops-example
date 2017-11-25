variable "az" {
  description = "The availability zone the instance will be in"
  type = "string"
}

variable "instance_id" {
  type = "string"
}

variable "ssh_host" {
  default = ""
  description = "The instance's SSH hostname. Default to the public_ip of the instance. Only needed if you're using an Elastic IP."
}

variable "ssh_user" {
  type = "string"
}

variable "device" {
  default = "/dev/xvdf"
  description = "Note this won't necessarily match the device_name on the aws_volume_attachment"
}

variable "owner" {
  description = "The user who should own the volume mount"
  type = "string"
}

variable "mount_dest" {
  type = "string"
}

variable "check_dir" {
  description = "Relative path to the mount_dest. If this directory is present, assume volume contains initial data."
  type = "string"
}
