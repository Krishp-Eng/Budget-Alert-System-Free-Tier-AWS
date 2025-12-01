variable "budget_name" {
  description = "Name of the AWS budget"
  type        = string
}

variable "limit" {
  description = "Budget limit amount in USD"
  type        = number
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
}

variable "time_unit" {
  description = "Time unit for the budget (MONTHLY, QUARTERLY, ANNUALLY)"
  type        = string
  default     = "MONTHLY"
}

variable "budget_type" {
  description = "Type of budget (COST, USAGE, RI_UTILIZATION, RI_COVERAGE)"
  type        = string
  default     = "COST"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
