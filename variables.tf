# BudgetSentinel - Simple Configuration
# Just the essentials for AWS cost protection

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "notification_email" {
  description = "Your email for budget alerts (REQUIRED)"
  type        = string
}

variable "slack_webhook" {
  description = "Slack webhook URL (optional - leave empty if you don't use Slack)"
  type        = string
  default     = ""
}

variable "budget_limit" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 50
}

variable "enable_automation" {
  description = "Auto-stop EC2/RDS when budget exceeded? (recommended: true)"
  type        = bool
  default     = true
}

