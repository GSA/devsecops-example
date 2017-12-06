resource "aws_cloudwatch_metric_alarm" "high_mem" {
  alarm_name                = "high-memory-wordpress"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html#using_put_script
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 memory utilization for the instance ${aws_instance.wordpress.id}"

  dimensions {
    InstanceId = "${aws_instance.wordpress.id}"
  }
}
