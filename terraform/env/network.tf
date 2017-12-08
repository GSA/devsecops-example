module "network" {
  source = "terraform-aws-modules/vpc/aws"

  azs = [
    "${data.aws_region.current.name}${var.azs[0]}",
    "${data.aws_region.current.name}${var.azs[1]}"
  ]

  name = "devsecops-example"

  enable_dns_hostnames = true
  enable_dns_support = true
  database_subnets = ["${var.database_subnet_cidrs}"]
  public_subnets = ["${var.public_subnet_cidr}"]
  enable_nat_gateway = true
  cidr = "${var.vpc_cidr}"
}

# ensure uniqueness within an account
resource "random_pet" "flow_logs" {}

module "flow_logs" {
  source = "github.com/GSA/terraform-vpc-flow-log"
  vpc_id = "${module.network.vpc_id}"
  prefix = "env-${random_pet.flow_logs.id}-"
}

data "aws_subnet" "public" {
  id = "${module.network.public_subnets[0]}"
}
