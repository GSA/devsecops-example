output "jenkins_host" {
  value = "${module.jenkins_instances.public_ip}"
}
