resource "aws_cloudwatch_event_bus" "example" {
  name = "example-event-bus"
}
resource "aws_sqs_queue" "gold_sqs" {
  name = "gold-sqs"
}

resource "aws_sqs_queue" "silver_sqs" {
  name = "silver-sqs"
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
