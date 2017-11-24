module "jenkins_networking" {
  source = "../../ansible/roles/gsa.jenkins/terraform/modules/networking"

  vpc_id = "${module.network.vpc_id}"
}

resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

module "jenkins_instances" {
  source = "../../ansible/roles/gsa.jenkins/terraform/modules/instances"

  ami = "${var.ami}"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${module.network.public_subnets[0]}"
  vpc_security_group_ids = ["${module.jenkins_networking.sg_id}"]
}
