module "network" {
  source = "terraform-aws-modules/vpc/aws"

  # Newest v1.11.0 released 12/11/17 fixes additional private subnet issue.
  version = ">= 1.11.0"

  azs = [
    "${data.aws_region.current.name}${var.azs[0]}",
    "${data.aws_region.current.name}${var.azs[1]}",
  ]

  name = "devsecops-example"

  enable_dns_hostnames = true
  enable_dns_support   = true
  database_subnets     = ["${cidrsubnet(var.vpc_cidr, 8, 101)}", "${cidrsubnet(var.vpc_cidr, 8, 102)}"]
  public_subnets       = ["${cidrsubnet(var.vpc_cidr, 8, 0)}"]
  enable_nat_gateway   = true
  cidr                 = "${var.vpc_cidr}"

  # per https://docs.aws.amazon.com/solutions/latest/cisco-based-transit-vpc/step3.html
  enable_vpn_gateway                 = true
  propagate_private_route_tables_vgw = true

  tags = {
    # only actually need it on the VPN gateway, but this is the only way to do it as of module 1.32.0
    # https://docs.aws.amazon.com/solutions/latest/cisco-based-transit-vpc/step3.html
    "transitvpc:spoke" = "true"
  }
}

module "spoke" {
  source = "github.com/GSA/grace-core//terraform/spoke"

  vpc_id = "${module.network.vpc_id}"
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
