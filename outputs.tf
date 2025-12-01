# Budget Outputs
# Essential information about cost protection setup

output "setup_complete" {
  description = "✅ Your AWS cost protection is active!"
  value       = "Budget: $${module.budget.budget_name} | Email: ${var.notification_email} | Auto-stop: ${var.enable_automation ? "enabled" : "disabled"}"
}

output "sns_topic_arn" {
  description = "SNS topic for budget alerts (for advanced users)"
  value       = module.alerts.sns_topic_arn
}

output "budget_name" {
  description = "Name of your AWS budget"
  value       = module.budget.budget_name
}

output "lambda_function_name" {
  description = "Auto-stop function name (for monitoring logs)"
  value       = module.automation.lambda_function_name
}
