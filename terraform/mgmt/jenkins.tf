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

locals {
  jenkins_ssh_user = "ec2-user"
}

module "jenkins_instances" {
  source = "../../ansible/roles/gsa.jenkins/terraform/modules/instances"

  ami = "${data.aws_ami.jenkins.id}"
  iam_instance_profile = "${module.jenkins_master_role.profile_name}"
  instance_type = "${var.jenkins_instance_type}"
  key_name = "${aws_key_pair.deployer.key_name}"
  subnet_id = "${module.network.public_subnets[0]}"
  vm_user = "${local.jenkins_ssh_user}"
  vpc_security_group_ids = ["${module.jenkins_networking.sg_id}"]
}

resource "aws_eip" "jenkins" {
  vpc = true
}

# the association needs to be done outside of the aws_eip resource so that the EIP can be created independent of the corresponding instance
resource "aws_eip_association" "jenkins" {
  instance_id   = "${module.jenkins_instances.instance_id}"
  allocation_id = "${aws_eip.jenkins.id}"
}

# https://tech.gogoair.com/immutable-jenkins-ae54e4a37a6a
module "jenkins_data" {
  source = "../modules/persistent_volume"

  az = "${data.aws_subnet.public.availability_zone}"
  instance_id = "${module.jenkins_instances.instance_id}"
  check_dir = "nodes"
  owner = "jenkins"
  mount_dest = "/var/lib/jenkins"
  ssh_user = "${local.jenkins_ssh_user}"

  # force the configuration to be read from disk
  post_mount = ["sudo systemctl restart jenkins"]

  # ensures the IP is associated before the volume is mounted
  # https://github.com/hashicorp/terraform/issues/557
  ssh_host = "${aws_eip.jenkins.public_ip}"
}
