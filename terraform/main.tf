terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"  # Specify the AWS provider version
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Your AWS region
}

# EventBridge Configuration
module "eventbridge" {
  source    = "./modules/eventbridge"
  name      = "my-event-bus1"
}

# EventBridge Rules Configuration
module "eventbridge_rules" {
  source    = "./modules/eventbridge_rules"
  event_bus = module.eventbridge.event_bus_name  # Pass the event bus name from the eventbridge module
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
  event_bus   = module.eventbridge.event_bus_name  # Pass the EventBus name
}

# API Gateway Configuration
module "api_gateway" {
  source          = "./modules/api_gateway"
  lambda_arn      = module.lambda.lambda_arn  # Ensure this ARN is correctly passed
  api_gateway_name = "client-api"
}
