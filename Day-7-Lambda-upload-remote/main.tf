resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-code-bucket-amit-2026"
}

resource "aws_s3_object" "lambda_zip" {
    bucket = aws_s3_bucket.lambda_bucket.bucket
    key = "lambda/amit.zip"
    source = "amit.zip"           # upload local ZIP to S3

    etag = filemd5("amit.zip")    # re-uploads when file changes
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# data "aws_iam_role" "lambda_role"{
#     name = "lambda-admin"
# }

resource "aws_lambda_function" "lambda_function" {
    function_name = "my-lambda"
    s3_bucket = aws_s3_bucket.lambda_bucket.bucket
    s3_key = aws_s3_object.lambda_zip.key
  
    role = aws_iam_role.lambda_role.arn
    handler = "amit.lambda_handler"
    runtime       = "python3.12"

    memory_size   = 128
    timeout       = 900

    # Detect ZIP code change
    source_code_hash = filebase64sha256("amit.zip")
}