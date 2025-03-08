# Define an output in the eventbridge module
output "event_bus_arn" {
  value = module.eventbridge.event_bus_arn
}
