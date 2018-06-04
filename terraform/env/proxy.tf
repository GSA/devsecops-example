resource "aws_lb" "egress_proxy_nlb" {
  load_balancer_type         = "network"
  internal                   = true
  subnets                    = ["${module.network.private_subnets}"]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "egress_proxy_nlb" {
  port        = "${var.egress_proxy_port}"
  protocol    = "TCP"
  vpc_id      = "${module.network.vpc_id}"
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "egress_proxy_nlb" {
  availability_zone = "all"
  target_group_arn  = "${aws_lb_target_group.egress_proxy_nlb.arn}"
  target_id         = "${aws_instance.egress_proxy.id}"
  port              = "${var.egress_proxy_port}"
}

resource "aws_lb_listener" "egress_proxy_nlb" {
  load_balancer_arn = "${aws_lb.egress_proxy_nlb.arn}"
  port              = "${var.egress_proxy_port}"
  protocol          = "TCP"

  "default_action" {
    target_group_arn = "${aws_lb_target_group.egress_proxy_nlb.arn}"
    type             = "forward"
  }
}

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
    from_port = "${var.egress_proxy_port}"
    to_port   = "${var.egress_proxy_port}"
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
