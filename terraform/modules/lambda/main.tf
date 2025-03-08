resource "aws_lambda_function" "lambda_client" {
  function_name = var.lambda_name
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  s3_bucket     = aws_s3_bucket.lambda_bucket.bucket
  s3_key        = "lambda-code.zip"  # You'll upload the zipped code here

  environment {
    variables = {
      EVENT_BUS_NAME = var.event_bus
    }
  }

  depends_on = [aws_iam_role.lambda_role]
}

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

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-policy"
  description = "Allow Lambda to put events to EventBridge"
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

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "lambda_arn" {
  value = aws_lambda_function.lambda_client.arn
}
