resource "aws_events_event_bus" "event_bus" {
  name = var.event_bus  # Using the passed variable
}

output "event_bus_name" {
  value = aws_events_event_bus.event_bus.name
}
