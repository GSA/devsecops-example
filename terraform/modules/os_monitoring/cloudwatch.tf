resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name                = "high-memory-${var.component}"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html#using_put_script
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "${var.high_memory_threshold}"
  alarm_description         = "This metric monitors ec2 memory utilization for the instance ${var.instance_id}"
  alarm_actions = ["${var.sns_topic_arn}"]

  dimensions {
    InstanceId = "${var.instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "high-cpu-${var.component}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "${var.high_cpu_threshold}"
  alarm_description         = "This metric monitors ec2 cpu utilization and alarms for 80% over two eval periods on instance ${var.instance_id}"
  alarm_actions = ["${var.sns_topic_arn}"]

  dimensions {
    InstanceId = "${var.instance_id}"
  }
  insufficient_data_actions = []
}
