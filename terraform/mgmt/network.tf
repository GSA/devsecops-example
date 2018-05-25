module "network" {
  source = "terraform-aws-modules/vpc/aws"

  # Newest v1.11.0 released 12/11/17 fixes additional private subnet issue.
  version = ">= 1.11.0"

  azs                  = ["${data.aws_region.current.name}${var.az}"]
  cidr                 = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  name                 = "devsecops-example-mgmt"
  public_subnets       = ["${cidrsubnet(var.vpc_cidr, 8, 0)}"]
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
