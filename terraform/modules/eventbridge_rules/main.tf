module "eventbridge_rules" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "3.14.3"

  event_bus_name = module.eventbridge.event_bus_name

  # Gold clients rule
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
    }
  ]

  # Silver clients rule
  rules = [
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
