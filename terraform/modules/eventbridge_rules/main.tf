module "eventbridge_rules" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.14.3"

  bus_name = module.eventbridge.bus_name  # Use bus_name to refer to the EventBridge bus

  rules = [
    {
      name = "gold-clients-rule"
      event_pattern = jsonencode({
        source = ["lambda-client1"]
        "detail-type" = ["client-details"]
        detail = {
          "client-type" = ["gold"]
        }
      })
      targets = [
        {
          arn = "arn:aws:sqs:us-west-2:123456789012:sqs-gold1"
          id  = "gold-clients-target"
        }
      ]
    },
    {
      name = "silver-clients-rule"
      event_pattern = jsonencode({
        source = ["lambda-client1"]
        "detail-type" = ["client-details"]
        detail = {
          "client-type" = ["silver"]
        }
      })
      targets = [
        {
          arn = "arn:aws:sqs:us-west-2:123456789012:sqs-silver1"
          id  = "silver-clients-target"
        }
      ]
    }
  ]
}
