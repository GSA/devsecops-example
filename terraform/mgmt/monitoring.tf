module "alerting" {
  source = "../modules/alerting"

  sns_general_availability_topic_name = "${var.sns_general_availability_topic_name}"
  general_availability_protocol = "${var.general_availability_protocol}"
  general_availability_endpoint = "${var.general_availability_endpoint}"
}
