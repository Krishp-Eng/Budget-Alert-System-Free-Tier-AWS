# Budget - Simple AWS Cost Protection
# Get email alerts when spending hits your budget + optionally auto-stop resources

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = var.aws_region
}

# Simple setup 
module "alerts" {
  source = "./modules/alerts"

  topic_name    = "budget-alerts"
  email         = var.notification_email
  slack_webhook = var.slack_webhook
  tags = {
    Project   = "BudgetSentinel"
    ManagedBy = "Terraform"
  }
}

module "budget" {
  source = "./modules/budget"

  budget_name   = "monthly-budget"
  limit         = var.budget_limit
  sns_topic_arn = module.alerts.sns_topic_arn
  tags = {
    Project   = "BudgetSentinel"
    ManagedBy = "Terraform"
  }
}

module "automation" {
  source = "./modules/automation"

  sns_topic_arn     = module.alerts.sns_topic_arn
  function_name     = "budget-sentinel-automation"
  enable_automation = var.enable_automation
  tags = {
    Project   = "BudgetSentinel"
    ManagedBy = "Terraform"
  }
}
