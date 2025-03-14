variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "event_bus" {
  description = "Event Bus name for Lambda to push events"
  type        = string
}
variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}
variable "role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}
