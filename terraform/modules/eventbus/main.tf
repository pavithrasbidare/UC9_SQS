resource "aws_cloudwatch_event_bus" "example" {
  name = "example-event-bus"
}

output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.example.arn
}
