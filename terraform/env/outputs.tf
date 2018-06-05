output "ssh_user" {
  value = "${var.ssh_user}"
}

output "public_ip" {
  value = "${aws_eip.public.public_ip}"
}

output "db_host" {
  value = "${aws_route53_record.db.fqdn}"
}

output "db_name" {
  value = "${aws_db_instance.wordpress.name}"
}

output "db_user" {
  value = "${aws_db_instance.wordpress.username}"
}

output "url" {
  value = "http://${aws_eip.public.public_ip}/blog/"
}

output "egress_proxy_port" {
  value = "${var.egress_proxy_port}"
}

output "egress_proxy_acls" {
  value = "${var.egress_proxy_acls}"
}
