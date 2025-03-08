resource "aws_events_rule" "gold_clients_rule" {
  name        = "gold-clients"
  event_bus_name = var.event_bus
  event_pattern = jsonencode({
    source      = ["lambda-client1"],
    "detail-type" = ["client-details"],
    detail      = {
      "client-type" = ["gold"]
    }
  })
  
  target {
    arn = module.sqs.gold_queue_url
    id  = "sqs-target-gold"
  }
}

resource "aws_events_rule" "silver_clients_rule" {
  name        = "silver-clients"
  event_bus_name = var.event_bus
  event_pattern = jsonencode({
    source      = ["lambda-client1"],
    "detail-type" = ["client-details"],
    detail      = {
      "client-type" = ["silver"]
    }
  })

  target {
    arn = module.sqs.silver_queue_url
    id  = "sqs-target-silver"
  }
}
