variable "instance_id" {
  type = "string"
}

variable "component" {
  type = "string"
}

variable "high_memory_threshold" {
  description = "Percent memory threshold for alarm on instance"
  default = "80"
}

variable "high_cpu_threshold" {
  description = "Percent CPU threshold for alarm on instance"
  default = "80"
}

variable "sns_topic_arn" {
  type = "string"
}
