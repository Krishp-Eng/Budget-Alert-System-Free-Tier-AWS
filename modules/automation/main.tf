# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  count       = var.enable_automation ? 1 : 0
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  count = var.enable_automation ? 1 : 0
  name  = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Lambda to stop EC2 and RDS instances
resource "aws_iam_role_policy" "lambda_policy" {
  count = var.enable_automation ? 1 : 0
  name  = "${var.function_name}-policy"
  role  = aws_iam_role.lambda_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:StopDBInstance"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "budget_automation" {
  count         = var.enable_automation ? 1 : 0
  filename      = data.archive_file.lambda_zip[0].output_path
  function_name = var.function_name
  role          = aws_iam_role.lambda_role[0].arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 300

  source_code_hash = data.archive_file.lambda_zip[0].output_base64sha256

  depends_on = [
    aws_iam_role_policy.lambda_policy,
    aws_cloudwatch_log_group.lambda_logs
  ]

  tags = var.tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  count             = var.enable_automation ? 1 : 0
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14

  tags = var.tags
}

# SNS Topic Subscription for Lambda
resource "aws_sns_topic_subscription" "lambda" {
  count     = var.enable_automation ? 1 : 0
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.budget_automation[0].arn
}

# Lambda Permission for SNS to invoke the function
resource "aws_lambda_permission" "allow_sns" {
  count         = var.enable_automation ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.budget_automation[0].function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}
