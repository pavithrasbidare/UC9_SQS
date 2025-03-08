output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.this.arn  # Ensure this is the correct reference
}
