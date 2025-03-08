provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

module "lambda" {
  source      = "./modules/lambda"
  lambda_name = "lambda-client1"
  event_bus   = module.eventbridge.event_bus_name
}

module "api_gateway" {
  source         = "./modules/api_gateway"
  lambda_arn     = module.lambda.lambda_arn
  api_gateway_name = "client-api"
}

module "sqs" {
  source     = "./modules/sqs"
  sqs_queue_1 = "sqs-gold1"
  sqs_queue_2 = "sqs-silver1"
}

module "eventbridge" {
  source = "./modules/eventbridge"
}

module "eventbridge_rules" {
  source        = "./modules/eventbridge_rules"
  event_bus     = module.eventbridge.event_bus_name  # This is the fix!
}

