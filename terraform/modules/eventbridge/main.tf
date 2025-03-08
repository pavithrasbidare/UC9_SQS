resource "aws_events_event_bus" "event_bus" {
  name = "my-event-bus1"
}

output "event_bus_name" {
  value = aws_events_event_bus.event_bus.name
}
