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

# EventBridge Configuration
module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  
  bus_name = "my-event-bus1"  # This is the correct argument name for the event bus

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
    # Define the targets for each rule
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

# EventBridge Rules Configuration
module "eventbridge_rules" {
  source    = "./modules/eventbridge_rules"
  event_bus = module.eventbridge.bus_name  # Pass the event bus name from the eventbridge module
}

# SQS Configuration
module "sqs" {
  source      = "./modules/sqs"
  sqs_queue_1 = "sqs-gold1"
  sqs_queue_2 = "sqs-silver1"
}

# Lambda Configuration
module "lambda" {
  source      = "./modules/lambda"
  lambda_name = "lambda-client1"
  event_bus   = module.eventbridge.bus_name  # Pass the EventBus name
}

# API Gateway Configuration
module "api_gateway" {
  source           = "./modules/api_gateway"
  lambda_arn       = module.lambda.lambda_arn  # Ensure this ARN is correctly passed
  api_gateway_name = "client-api"
}
