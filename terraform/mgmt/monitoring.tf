module "alerting" {
  source = "../modules/alerting"

  sns_general_availability_topic_name = "${var.sns_general_availability_topic_name}"
  general_availability_protocol = "${var.general_availability_protocol}"
  general_availability_endpoint = "${var.general_availability_endpoint}"
}

module "ekk_stack" {
  source = "github.com/GSA/devsecops-ekk-stack//terraform"

  s3_logging_bucket_name = "${var.s3_logging_bucket_name}"
  kinesis_delivery_stream = "${var.kinesis_delivery_stream}"
  ekk_kinesis_stream_name = "${var.ekk_kinesis_stream_name}"
}
