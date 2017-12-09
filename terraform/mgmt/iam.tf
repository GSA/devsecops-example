# avoid name conflicts - ensure multiple copies of the same role can exist in the same AWS account
resource "random_id" "jenkins_iam_role_suffix" {
  byte_length = 8
}

module "jenkins_master_role" {
  source = "github.com/18F/cg-provision/terraform/modules/iam_role"
  iam_policy = "${file("${path.module}/files/role_policy.json")}"
  role_name = "${var.jenkins_iam_role_prefix}${random_id.jenkins_iam_role_suffix.hex}"
}
