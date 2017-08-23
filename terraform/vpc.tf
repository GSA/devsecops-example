data "aws_region" "current" {
  current = true
}

module "vpc" {
  source = "github.com/terraform-community-modules/tf_aws_vpc"

  name = "devsecops-example"

  cidr = "10.0.0.0/16"
  public_subnets  = ["10.0.0.0/24"]
  database_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = "true"

  azs = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]

  tags {
    "Terraform" = "true"
    "Repository" = "https://github.com/GSA/devsecops-example"
  }
}

data "aws_vpc" "drupal" {
  id = "${module.vpc.vpc_id}"
}
