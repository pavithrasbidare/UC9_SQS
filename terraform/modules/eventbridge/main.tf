module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.14.3"  # Ensure you're using the correct version of the module

  bus_name = "my-event-bus1"  # Use bus_name as the argument for the EventBridge event bus name
}

output "event_bus_name" {
  value = module.eventbridge.event_bus_name
}
