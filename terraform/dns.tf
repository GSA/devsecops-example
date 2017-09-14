data "aws_route53_zone" "private" {
  name = "${module.network.private_mgmt_dns_zone_name}"
  private_zone = true
}

resource "aws_route53_record" "db" {
  zone_id = "${data.aws_route53_zone.private.zone_id}"
  name = "db"
  type = "CNAME"
  ttl = "30"
  records = ["${aws_db_instance.wordpress.address}"]
}
