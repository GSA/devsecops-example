module "network" {
  source = "terraform-aws-modules/vpc/aws"

  azs = [
    "${data.aws_region.current.name}d",
    "${data.aws_region.current.name}f"
  ]

  name = "devsecops-example"

  enable_dns_hostnames = true
  enable_dns_support = true
  database_subnets = ["${var.database_subnet_cidrs}"]
  public_subnets = ["${var.public_subnet_cidr}"]
  enable_nat_gateway = true
  cidr = "${var.vpc_cidr}"
}

module "flow_logs" {
  source = "git::https://github.com/GSA/DevSecOps.git?ref=fb535d3//terraform/modules/vpc_flow_log"

  vpc_id = "${module.network.vpc_id}"
  // not actually the name, but required by this module
  vpc_name = "devsecops-example"
}
