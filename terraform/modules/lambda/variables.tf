variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "event_bus" {
  description = "Event Bus name for Lambda to push events"
  type        = string
}
