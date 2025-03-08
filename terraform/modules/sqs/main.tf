resource "aws_sqs_queue" "gold_queue" {
  name = var.sqs_queue_1
}

resource "aws_sqs_queue" "silver_queue" {
  name = var.sqs_queue_2
}

output "gold_queue_url" {
  value = aws_sqs_queue.gold_queue.url
}

output "silver_queue_url" {
  value = aws_sqs_queue.silver_queue.url
}
