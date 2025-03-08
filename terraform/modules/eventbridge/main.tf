module "eventbridge" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.14.3"  # Ensure you're using the correct version of the module

  name = "my-event-bus1"  # Name of your EventBridge event bus
}

output "event_bus_name" {
  value = module.eventbridge.event_bus_name
}
