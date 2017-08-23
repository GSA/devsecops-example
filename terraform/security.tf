resource "aws_security_group" "drupal_ec2" {
  name = "drupal"
  description = "rules for production traffic"
  vpc_id = "${module.vpc.vpc_id}"
  tags {
    Name = "Drupal EC2 rules"
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

resource "aws_security_group" "drupal_db" {
  name        = "Drupal (DB)"
  description = "RDS security group for Drupal."
  vpc_id      = "${data.aws_vpc.drupal.id}"
  tags {
    Name = "Drupal RDS rules"
  }

  ingress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["${data.aws_vpc.drupal.cidr_block}"]
  }

  egress {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["${data.aws_vpc.drupal.cidr_block}"]
  }
}
