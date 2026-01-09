provider "aws" {
  region = "eu-north-1"
}

# 1️⃣ S3 Bucket
resource "aws_s3_bucket" "upload_bucket" {
  bucket = "amit-s3-lambda-trigger-bucket"
}

# 2️⃣ Upload Lambda Zip to S3 or use local
resource "aws_lambda_function" "lambda_fun" {
  function_name = "s3-file-trigger-lambda"
  filename         = "lambda_function.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = filebase64sha256("lambda_function.zip")
}

# 3️⃣ IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach AWSLambdaBasicExecutionRole
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# 4️⃣ S3 → Lambda Trigger
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_fun.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"   # optional
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# 5️⃣ Allow S3 to invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_fun.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.upload_bucket.arn
}
