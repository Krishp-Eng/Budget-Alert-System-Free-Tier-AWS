# AWS Budget with notifications
resource "aws_budgets_budget" "main" {
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = var.limit
  limit_unit        = "USD"
  time_unit         = var.time_unit
  time_period_start = formatdate("YYYY-MM-01_00:00", timestamp())

  cost_filter {
    name   = "Service"
    values = ["Amazon Elastic Compute Cloud - Compute", "Amazon Relational Database Service"]
  }

  # 80% threshold notification
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = []
    subscriber_sns_topic_arns  = [var.sns_topic_arn]
  }

  # 100% threshold notification
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = []
    subscriber_sns_topic_arns  = [var.sns_topic_arn]
  }

  # Forecasted 100% threshold notification
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = []
    subscriber_sns_topic_arns  = [var.sns_topic_arn]
  }

  depends_on = [var.sns_topic_arn]
}
