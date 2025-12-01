variable "topic_name" {
  description = "Name of the SNS topic for budget alerts"
  type        = string
}

variable "email" {
  description = "Email address for budget notifications"
  type        = string
}

variable "slack_webhook" {
  description = "Slack webhook URL for notifications (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
