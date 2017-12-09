module "network" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 1.0"

  azs = ["${data.aws_region.current.name}${var.az}"]
  cidr = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  name = "devsecops-example-mgmt"
  public_subnets = ["${var.public_subnet_cidr}"]
}

# ensure uniqueness within an account
resource "random_pet" "flow_logs" {}

module "flow_logs" {
  source = "github.com/GSA/terraform-vpc-flow-log"
  vpc_id = "${module.network.vpc_id}"
  prefix = "mgmt-${random_pet.flow_logs.id}-"
}

data "aws_subnet" "public" {
  id = "${module.network.public_subnets[0]}"
}
