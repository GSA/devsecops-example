resource "aws_security_group" "wordpress_ec2" {
  name = "wordpress"
  description = "rules for production traffic"
  vpc_id = "${module.network.mgmt_vpc_id}"
  tags {
    Name = "WordPress EC2 rules"
  }

  # HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  # SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.ip_whitelist}",
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wordpress_db" {
  name        = "WordPress (DB)"
  description = "RDS security group for WordPress."
  vpc_id      = "${module.network.mgmt_vpc_id}"
  tags {
    Name = "WordPress RDS rules"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
}
