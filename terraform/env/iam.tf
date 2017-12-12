// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html#using_put_examples
module "wordpress_role" {
  source = "github.com/18F/cg-provision/terraform/modules/iam_role"
  iam_policy = "${file("${path.module}/files/role_policy.json")}"
  role_name = "${var.wordpress_iam_role_name}"
}
