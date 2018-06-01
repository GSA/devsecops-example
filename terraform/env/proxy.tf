data "aws_ami" "egress_proxy" {
  most_recent = true

  filter {
    name   = "name"
    values = ["egress_proxy *"]
  }

  owners = ["self"]
}

resource "aws_instance" "egress_proxy" {
  ami                    = "${data.aws_ami.egress_proxy.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${data.aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.egress_proxy.id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"

  iam_instance_profile = "${module.egress_proxy_role.profile_name}"

  tags {
    Name = "Egress Proxy"
  }

  provisioner "remote-exec" {
    inline = ["echo Successfully connected"]

    connection {
      user = "${var.ssh_user}"
    }
  }
}

resource "aws_security_group" "egress_proxy" {
  name        = "egress_proxy"
  description = "rules for production traffic"
  vpc_id      = "${module.network.vpc_id}"

  tags {
    Name = "Egress Proxy EC2 rules"
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  # SSH
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${var.ip_whitelist}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "egress_proxy_role" {
  source     = "github.com/18F/cg-provision/terraform/modules/iam_role"
  iam_policy = "${file("${path.module}/files/role_policy.json")}"
  role_name  = "${var.egress_proxy_iam_role_name}"
}
