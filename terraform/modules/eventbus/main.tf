provider "aws" {
  region = "us-east-1"  # Specify your desired region
}

resource "aws_cloudwatch_event_bus" "example" {
  name = "example-event-bus"
}

resource "aws_sqs_queue" "gold_sqs" {
  name = "gold-sqs"
}

resource "aws_sqs_queue" "silver_sqs" {
  name = "silver-sqs"
}

resource "aws_cloudwatch_event_rule" "gold_rule" {
  name           = "gold-rule"
  event_bus_name = aws_cloudwatch_event_bus.example.name
  event_pattern  = jsonencode({
    "source": ["insert_data_lambda"],
  "detail-type": ["client-details"],
  "detail": {
    "client-type": ["gold1"]
    }
  })
}

resource "aws_cloudwatch_event_rule" "silver_rule" {
  name           = "silver-rule"
  event_bus_name = aws_cloudwatch_event_bus.example.name
  event_pattern  = jsonencode({
    "source": ["insert_data_lambda"],
  "detail-type": ["client-details"],
  "detail": {
    "client-type": ["silver1"]
    }
  })
}

output "gold_sqs_url" {
  value = aws_sqs_queue.gold_sqs.url
}

output "silver_sqs_url" {
  value = aws_sqs_queue.silver_sqs.url
}

output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.example.arn
}

output "event_bus_name" {
  value = aws_cloudwatch_event_bus.example.name
}
