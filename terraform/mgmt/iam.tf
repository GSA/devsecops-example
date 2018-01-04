resource "aws_iam_user" "deployer" {
  name = "${var.deployer_username}"
}

resource "aws_iam_user_policy" "deployer" {
  name = "deployer-policy"
  user = "${aws_iam_user.deployer.name}"

  policy = "${file("${path.module}/files/deployer_policy.json")}"
}
