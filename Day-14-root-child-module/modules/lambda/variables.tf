# ------------ Lambda Function Variables ------------

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 10
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "ap-south-1"
}
