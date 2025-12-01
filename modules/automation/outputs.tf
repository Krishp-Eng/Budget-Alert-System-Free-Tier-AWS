output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = var.enable_automation ? aws_lambda_function.budget_automation[0].function_name : null
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = var.enable_automation ? aws_lambda_function.budget_automation[0].arn : null
}
