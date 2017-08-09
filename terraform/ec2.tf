resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "drupal" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.drupal_a.id}"
  security_groups = ["${aws_security_group.drupal_ec2.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"

  tags {
    Name = "Drupal"
  }

  provisioner "local-exec" {
    command = "echo Successfully connected"
  }
}
