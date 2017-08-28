output "public_ip" {
  value = "${aws_instance.wordpress.public_ip}"
}

output "public_subnet_id" {
  value = "${module.vpc.public_subnets[0]}"
}

output "db_host" {
  value = "${aws_db_instance.wordpress.endpoint}"
}

output "db_name" {
  value = "${aws_db_instance.wordpress.name}"
}

output "db_user" {
  value = "${aws_db_instance.wordpress.username}"
}

output "db_pass" {
  value = "${aws_db_instance.wordpress.password}"
}
