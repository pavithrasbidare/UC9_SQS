# Archive Lambda Code as ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./lambda_file/lambda_function.py"  # Path to your Python Lambda code
  output_path = "${path.module}/lambda-code.zip"  # Output ZIP file to be used for Lambda function
}

# IAM Role for Lambda Function
resource "aws_iam_role" "lambda_role" {
  name               = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# IAM Policy for Lambda Function
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "Allow Lambda to put events to EventBridge and send messages to SQS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "events:PutEvents"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "sqs:SendMessage"
        Resource = "*"
        Effect   = "Allow"
      }
    ]
  })
}

# Attach IAM Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Function Resource (using the ZIP file created above)
resource "aws_lambda_function" "lambda_client" {
  function_name = var.lambda_name
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  filename      = data.archive_file.lambda_zip.output_path  # Use the generated ZIP file

  environment {
    variables = {
      EVENT_BUS_NAME = var.event_bus
    }
  }

  depends_on = [aws_iam_role.lambda_role]
}

# Output Lambda ARN
output "lambda_arn" {
  value = aws_lambda_function.lambda_client.arn
}
