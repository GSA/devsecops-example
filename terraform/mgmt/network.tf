module "network" {
  source = "terraform-aws-modules/vpc/aws"

  # somewhat arbitrary - the later in the alphabet, the newer, which seems to provision faster
  azs = ["${data.aws_region.current.name}c"]
  cidr = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  name = "devsecops-example-mgmt"
  public_subnets = ["${var.public_subnet_cidr}"]
}

module "flow_logs" {
  source = "github.com/GSA/terraform-vpc-flow-log"
  vpc_id = "${module.network.vpc_id}"
  # temporary, while working in a single account
  prefix = "mgmt"
}
