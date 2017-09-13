module "network" {
  source = "github.com/GSA/DevSecOps-Infrastructure/terraform"

  aws_az1 = "${data.aws_region.current.name}d"
  aws_az2 = "${data.aws_region.current.name}f"

  mgmt_vpc_name = "devsecops-example"
  private_mgmt_zone_name = "${var.private_zone_name}"
}
