provider "aws" {
  region = "us-east-1"  # Specify your desired region
}

module "lambda" {
  source        = "./modules/lambda"
  function_name = "insert_data_lambda"
  role_arn      = module.iam.lambda_role_arn
}

module "api_gateway" {
  source           = "./modules/api_gateway"
  lambda_arn       = module.lambda.lambda_arn
  api_gateway_name = "my-api-gateway"
  region           = "us-east-1"
}

module "eventbus" {
  source = "./modules/eventbus"
}

output "api_url" {
  value = module.api_gateway.api_url
}

output "gold_sqs_url" {
  value = module.eventbus.gold_sqs_url
}

output "silver_sqs_url" {
  value = module.eventbus.silver_sqs_url
}

output "event_bus_arn" {
  value = module.eventbus.event_bus_arn
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}
