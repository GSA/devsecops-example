data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name = "name"
    values = ["wordpress *"]
  }

  owners = ["self"]
}

resource "aws_instance" "wordpress" {
  ami = "${data.aws_ami.wordpress.id}"
  instance_type = "t2.micro"
  subnet_id = "${data.aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_ec2.id}"]

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

resource "aws_eip" "public" {
  instance = "${aws_instance.wordpress.id}"
  vpc = true
}

module "wp_content" {
  source = "../modules/persistent_volume"

  az = "${data.aws_subnet.public.availability_zone}"
  instance_id = "${aws_instance.wordpress.id}"
  check_dir = "themes"
  owner = "www-data"
  mount_dest = "/usr/share/wordpress/wp-content"
  ssh_user = "${var.ssh_user}"

  # ensures the IP is associated before the volume is mounted
  # https://github.com/hashicorp/terraform/issues/557
  ssh_host = "${aws_eip.public.public_ip}"
}
