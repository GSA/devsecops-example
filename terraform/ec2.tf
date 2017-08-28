resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "wordpress" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${module.vpc.public_subnets[0]}"
  vpc_security_group_ids = ["${aws_security_group.wordpress_ec2.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  tags {
    Name = "WordPress"
  }

  provisioner "local-exec" {
    command = "echo Successfully connected"
  }
}
