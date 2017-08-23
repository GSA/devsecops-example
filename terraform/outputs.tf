output "public_ip" {
  value = "${aws_instance.drupal.public_ip}"
}

output "public_subnet_id" {
  value = "${module.vpc.public_subnets[0]}"
}
