data "aws_region" "current" {
  current = true
}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "devsecops-example"

  cidr = "${var.vpc_cidr}"
  public_subnets  = ["${var.public_subnet_cidr}"]
  database_subnets = ["${var.database_subnet_cidrs}"]

  enable_nat_gateway = "true"

  azs = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]

  tags {
    "Terraform" = "true"
    "Repository" = "https://github.com/GSA/devsecops-example"
  }
}
