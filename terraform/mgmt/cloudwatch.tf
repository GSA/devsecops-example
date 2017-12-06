resource "aws_cloudwatch_metric_alarm" "high_memory_jenkins" {
  alarm_name                = "high-memory-jenkins"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html#using_put_script
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"

  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "${var.high_memory_jenkins_alarm_threshold}"
  alarm_description         = "This metric monitors ec2 memory utilization for the instance ${module.jenkins_instances.instance_id}"
  alarm_actions = ["${aws_sns_topic.sns_general_availability.arn}"]

  dimensions {
    InstanceId = "${module.jenkins_instances.instance_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_wordpress" {
  alarm_name                = "high-cpu-wordpress"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "${var.high_cpu_jenkins_alarm_threshold}"
  alarm_description         = "This metric monitors ec2 cpu utilization and alarms for 80% over two eval periods on instance $${module.jenkins_instances.instance_id}"
  alarm_actions = ["${aws_sns_topic.sns_general_availability.arn}"]

  dimensions {
    InstanceId = "${module.jenkins_instances.instance_id}"
  }
  insufficient_data_actions = []
}
