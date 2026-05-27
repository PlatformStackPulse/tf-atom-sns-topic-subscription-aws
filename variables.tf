variable "topic_arn" {
  description = "ARN of the SNS topic"
  type        = string
  validation {
    condition     = length(var.topic_arn) > 0
    error_message = "topic_arn must not be empty."
  }
}

variable "protocol" {
  description = "Protocol (sqs, lambda, email, https, http, sms)"
  type        = string
  validation {
    condition     = contains(["sqs", "lambda", "email", "email-json", "https", "http", "sms", "application"], var.protocol)
    error_message = "protocol must be a valid SNS subscription protocol."
  }
}

variable "endpoint" {
  description = "Endpoint to receive notifications"
  type        = string
  validation {
    condition     = length(var.endpoint) > 0
    error_message = "endpoint must not be empty."
  }
}

variable "raw_message_delivery" {
  description = "Whether to enable raw message delivery"
  type        = bool
  default     = false
}

variable "filter_policy" {
  description = "JSON filter policy for message filtering"
  type        = string
  default     = null
}
