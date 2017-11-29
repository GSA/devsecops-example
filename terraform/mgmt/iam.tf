module "jenkins_master_role" {
  source = "github.com/18F/cg-provision/terraform/modules/iam_role"
  iam_policy = "${file("${path.module}/files/role_policy.json")}"
  role_name = "${var.jenkins_iam_role_name}"
}
