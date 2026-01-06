data "aws_iam_role" "lambda_role" {
  name = "lambda-admin"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = data.aws_iam_role.lambda_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128
  filename = "app.zip"

 
  source_code_hash = filebase64sha256("app.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.
}