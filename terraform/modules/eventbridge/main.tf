module "eventbridge" {
  source    = "terraform-aws-modules/eventbridge/aws"
  version   = "3.14.3"  # Ensure you're using the correct version of the module

  event_bus_name = "my-event-bus1"  # Correct argument name for EventBus
}

output "event_bus_name" {
  value = module.eventbridge.event_bus_name
}
