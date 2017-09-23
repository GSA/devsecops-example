module "network" {
  source = "github.com/GSA/DevSecOps-Infrastructure/terraform"

  aws_az1 = "${data.aws_region.current.name}d"
  aws_az2 = "${data.aws_region.current.name}f"

  mgmt_vpc_name = "devsecops-example"
  private_mgmt_zone_name = "${var.private_zone_name}"

  devsecops_flow_log_policy = "devsecops_example_flow_log"
  mgmt_private_subnet_cidrs = ["${var.vpc_cidr}"]
  mgmt_dns_hostnames = "true"
  mgmt_dns_support = "true"
  mgmt_database_subnet_cidrs = ["${var.database_subnet_cidrs}"]
  mgmt_public_subnet_cidrs = ["${var.public_subnet_cidr}"]
  mgmt_nat_gateway = "true"
  mgmt_flow_log_group_name = "devsecops_example_flow_log"
  devsecops_iam_log_role_name = "devsecops_example_flow_log"
  aws_region = "${data.aws_region.current.name}"
  mgmt_vpc_cidr = "${var.vpc_cidr}"
}
