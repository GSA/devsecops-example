resource "aws_route53_zone" "private" {
  name = "${var.private_zone_name}"
  // this argument makes it a Private Hosted Zone
  vpc_id = "${module.network.vpc_id}"
}

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name = "db"
  type = "CNAME"
  ttl = "30"
  records = ["${aws_db_instance.wordpress.address}"]
}
