output "jenkins_host" {
  value = "${aws_eip.jenkins.public_ip}"
}
