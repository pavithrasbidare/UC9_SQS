terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version is removed to allow using the latest version compatible with Terraform
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Your AWS region
}

# SQS Queue Resources (define these directly in the root module)
resource "aws_sqs_queue" "sqs_gold1" {
  name = "sqs-gold1"
}

resource "aws_sqs_queue" "sqs_gold_dlq" {
  name = "sqs-gold-dlq"
}

resource "aws_sqs_queue" "sqs_silver1" {
  name = "sqs-silver1"
}

resource "aws_sqs_queue" "sqs_silver_dlq" {
  name = "sqs-silver-dlq"
}

# EventBridge Configuration
module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  
  bus_name = "my-event-bus1"  # EventBus name

  rules = {
    # Define your rules for eventbridge
    gold_clients_rule = {
      description   = "Capture all gold clients"
      event_pattern = jsonencode({
        "source"     = ["lambda-client1"],
        "detail-type" = ["client-details"],
        "detail"      = { "client-type" = ["gold"] }
      })
      enabled = true
    },
    silver_clients_rule = {
      description   = "Capture all silver clients"
      event_pattern = jsonencode({
        "source"     = ["lambda-client1"],
        "detail-type" = ["client-details"],
        "detail"      = { "client-type" = ["silver"] }
      })
      enabled = true
    }
  }

  targets = {
    gold_clients_rule = [
      {
        name            = "send-gold-clients-to-sqs"
        arn             = aws_sqs_queue.sqs_gold1.arn
        dead_letter_arn = aws_sqs_queue.sqs_gold_dlq.arn
      }
    ],
    silver_clients_rule = [
      {
        name            = "send-silver-clients-to-sqs"
        arn             = aws_sqs_queue.sqs_silver1.arn
        dead_letter_arn = aws_sqs_queue.sqs_silver_dlq.arn
      }
    ]
  }

  tags = {
    Name = "my-event-bus1"
  }
}

# Lambda Configuration
module "lambda" {
  source      = "./modules/lambda"
  lambda_name = "lambda-client1"
  event_bus   = module.eventbridge.event_bus_arn  # Reference the correct output
}

# API Gateway Configuration
module "api_gateway" {
  source           = "./modules/api_gateway"
  lambda_arn       = module.lambda.lambda_arn  # Ensure this ARN is correctly passed
  api_gateway_name = "client-api"
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "gold_queue_url" {
  value = aws_sqs_queue.sqs_gold1.id  # Output the SQS queue URL directly
}

output "silver_queue_url" {
  value = aws_sqs_queue.sqs_silver1.id  # Output the SQS queue URL directly
}
