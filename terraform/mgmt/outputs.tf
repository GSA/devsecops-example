output "public_subnet_id" {
  value = "${module.network.public_subnets[0]}"
}

output "jenkins_host" {
  value = "${module.jenkins_instances.public_ip}"
}
