output "api_url" {
  value = module.api_gateway.api_url
}

output "gold_queue_url" {
  value = module.sqs.gold_queue_url
}

output "silver_queue_url" {
  value = module.sqs.silver_queue_url
}
