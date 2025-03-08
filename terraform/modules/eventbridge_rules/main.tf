resource "aws_events_rule" "gold_clients_rule" {
  name           = "gold-clients-rule"
  event_bus_name = aws_events_event_bus.event_bus.name

  event_pattern = jsonencode({
    source     = ["lambda-client1"]
    "detail-type" = ["client-details"]
    detail = {
      "client-type" = ["gold"]
    }
  })

  target {
    arn = "arn:aws:sqs:us-west-2:123456789012:sqs-gold1"
    id  = "gold-clients-target"
  }
}

resource "aws_events_rule" "silver_clients_rule" {
  name           = "silver-clients-rule"
  event_bus_name = aws_events_event_bus.event_bus.name

  event_pattern = jsonencode({
    source     = ["lambda-client1"]
    "detail-type" = ["client-details"]
    detail = {
      "client-type" = ["silver"]
    }
  })

  target {
    arn = "arn:aws:sqs:us-west-2:123456789012:sqs-silver1"
    id  = "silver-clients-target"
  }
}
