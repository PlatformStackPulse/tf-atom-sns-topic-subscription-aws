resource "aws_sns_topic_subscription" "this" {
  count = module.this.enabled ? 1 : 0

  topic_arn            = var.topic_arn
  protocol             = var.protocol
  endpoint             = var.endpoint
  raw_message_delivery = var.raw_message_delivery
  filter_policy        = var.filter_policy
}
