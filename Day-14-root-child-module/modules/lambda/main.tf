# -------------------- IAM Role --------------------

resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Basic logging policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -------------------- Lambda Function --------------------

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  runtime       = var.runtime
  handler       = var.handler
  role          = aws_iam_role.lambda_role.arn

  memory_size = var.memory_size
  timeout     = var.timeout

  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = var.environment_variables
  }
}
