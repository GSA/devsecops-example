module "alerting" {
  source = "../modules/alerting"

  sns_general_availability_topic_name = "${var.sns_general_availability_topic_name}"
  general_availability_protocol = "${var.general_availability_protocol}"
  general_availability_endpoint = "${var.general_availability_endpoint}"
}

module "os_monitoring" {
  source = "../modules/os_monitoring"

  instance_id = "${aws_instance.wordpress.id}"
  component = "wordpress"
  sns_topic_arn = "${module.alerting.sns_topic_arn}"
  high_cpu_threshold = "${var.high_cpu_wordpress_alarm_threshold}"
  high_memory_threshold = "${var.high_memory_wordpress_alarm_threshold}"
  high_disk_util_threshold = "${var.high_disk_util_wordpress_alarm_threshold}"
}

