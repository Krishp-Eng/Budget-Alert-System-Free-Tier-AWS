output "budget_id" {
  description = "ID of the created budget"
  value       = aws_budgets_budget.main.id
}

output "budget_name" {
  description = "Name of the created budget"
  value       = aws_budgets_budget.main.name
}
