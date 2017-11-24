module "jenkins_networking" {
  source = "../../ansible/roles/gsa.jenkins/terraform/modules/networking"

  vpc_id = "${module.network.vpc_id}"
}

resource "aws_key_pair" "deployer" {
  key_name_prefix = "deployer-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

data "aws_ami" "jenkins" {
  most_recent = true

  filter {
    name = "name"
    values = ["jenkins *"]
  }

  owners = ["self"]
}

module "jenkins_instances" {
  source = "../../ansible/roles/gsa.jenkins/terraform/modules/instances"

  ami = "${data.aws_ami.jenkins.id}"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${module.network.public_subnets[0]}"
  vpc_security_group_ids = ["${module.jenkins_networking.sg_id}"]
}

resource "aws_eip" "jenkins" {
  instance = "${module.jenkins_instances.instance_id}"
  vpc = true
}
