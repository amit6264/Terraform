resource "aws_s3_bucket" "s3_bucket" {
  bucket = "amit-lambda-file-upload"
}

resource "aws_s3_object" "zip_file" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key = "lambda_test.zip"
  source = "./lambda_test.zip"

  etag = filemd5("./lambda_test.zip")
}


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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


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