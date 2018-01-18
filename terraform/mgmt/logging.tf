# temporary, until we have an image for this
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "log_forwarding" {
  name          = "log-forwarding"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "log_forwarding" {
  availability_zones = ["${local.azs}"]
  vpc_zone_identifier = ["${module.network.private_subnets}"]
  # will likely switch to Launch Template once available
  # https://github.com/terraform-providers/terraform-provider-aws/issues/2505
  launch_configuration      = "${aws_launch_configuration.log_forwarding.name}"

  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2

  tag {
    key                 = "Component"
    value               = "log-forwarding"
    propagate_at_launch = true
  }
}
