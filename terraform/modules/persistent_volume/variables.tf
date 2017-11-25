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


variable "volume_type" {
  default = "gp2"
  description = "'API Name' from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html"
}

variable "size" {
  default = 10
  description = "The size of the volume, in GB"
}

variable "external_device_name" {
  default = "/dev/sdf"
  description = "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html"
}

variable "internal_device_name" {
  default = "/dev/xvdf"
  description = "Note this won't necessarily match the external_device_name - see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html"
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

variable "post_mount" {
  default = []
  description = "Commands to run on the instance after the volume is mounted"
}
