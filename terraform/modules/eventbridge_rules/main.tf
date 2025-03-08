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
          arn = aws_sqs_queue.sqs_gold1.arn  # Use the ARN from the main module
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
          arn = aws_sqs_queue.sqs_silver1.arn  # Use the ARN from the main module
          id  = "silver-clients-target"
        }
      ]
    }
  ]
}
