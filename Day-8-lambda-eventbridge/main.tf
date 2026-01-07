provider "aws" {
  region = "us-east-1"
}

# creation of s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "amit-lambda-file-upload"
}

# Put file into inside s3 bucket
resource "aws_s3_object" "zip_file" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key = "lambda_test.zip"
  source = "./lambda_test.zip"

  etag = filemd5("./lambda_test.zip")
}

# Lambda take file from s3 so want some permission (policy)
resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-access-policy"
  description = "Allow Lambda to read objects from S3 and write CloudWatch logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::amit-lambda-file-upload",
          "arn:aws:s3:::amit-lambda-file-upload/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create role for the policy
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Creation of Lambda function and take file from s3
resource "aws_lambda_function" "lambda_function" {
    function_name = "my-lambda"
    s3_bucket = aws_s3_bucket.s3_bucket.bucket
    s3_key = aws_s3_object.zip_file.key
  
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_test.lambda_handler"
    runtime       = "python3.12"

    memory_size   = 128
    timeout       = 900

    # Detect ZIP code change
    source_code_hash = filebase64sha256("lambda_test.zip")
}

# Create EventBridge rule (schedule)
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Trigger Lambda every 5 minutes"
#   schedule_expression = "rate(5 minutes)"
  schedule_expression = "cron(0/5 * * * ? *)"
}

# Add the Lambda target
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.lambda_function.arn
}

# Allow EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}