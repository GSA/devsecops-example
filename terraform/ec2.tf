resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name = "name"
    values = ["wordpress *"]
  }

  owners = ["self"]
}

data "aws_subnet" "public" {
  id = "${module.vpc.public_subnets[0]}"
}

resource "aws_instance" "wordpress" {
  ami = "${data.aws_ami.wordpress.id}"
  instance_type = "t2.micro"
  subnet_id = "${data.aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_ec2.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  tags {
    Name = "WordPress"
  }

  provisioner "remote-exec" {
    inline = ["echo Successfully connected"]

    connection {
      user = "${var.ssh_user}"
    }
  }
}

resource "aws_ebs_volume" "wp_content" {
  # TODO deletion protection
  availability_zone = "${data.aws_subnet.public.availability_zone}"
  size = 10
}

resource "aws_volume_attachment" "wp_content" {
  device_name = "/dev/sdf"
  volume_id = "${aws_ebs_volume.wp_content.id}"
  instance_id = "${aws_instance.wordpress.id}"

  # https://github.com/hashicorp/terraform/issues/2740#issuecomment-288549352
  skip_destroy = true
  provisioner "remote-exec" {
    script = "files/attach-data-volume.sh"
    connection {
      user = "${var.ssh_user}"
      host = "${aws_instance.wordpress.public_ip}"
    }
  }
}
