resource "aws_iam_role" "jenkins" {
  name_prefix = "jenkins_role_"
  assume_role_policy = "${file("${path.module}/files/assume_role_policy.json")}"
}

resource "aws_iam_instance_profile" "jenkins" {
  name_prefix = "jenkins_profile_"
  role = "${aws_iam_role.jenkins.name}"
}

// https://adrianhesketh.com/2016/06/27/creating-aws-instance-roles-with-terraform/
resource "aws_iam_role_policy" "jenkins" {
  name_prefix = "jenkins_role_policy_"
  role = "${aws_iam_role.jenkins.id}"
  policy = "${file("${path.module}/files/role_policy.json")}"
}
