output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "arn" {
  description = "ARN of the subscription"
  value       = try(aws_sns_topic_subscription.this[0].arn, null)
}

output "id" {
  description = "ID of the subscription"
  value       = try(aws_sns_topic_subscription.this[0].id, null)
}
