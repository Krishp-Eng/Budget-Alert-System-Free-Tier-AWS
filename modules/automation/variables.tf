variable "sns_topic_arn" {
  description = "ARN of the SNS topic to subscribe to for budget alerts"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "budget-sentinel-automation"
}

variable "enable_automation" {
  description = "Whether to enable the automation Lambda function"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
