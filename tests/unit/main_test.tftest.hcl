# Unit tests for tf-atom-sns-topic-subscription-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run one test:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: computed attributes (arn, id) are unknown under a mock provider, so we
# only assert on plan-known values: the tf-label id, resource count, and the
# enabled pass-through.

mock_provider "aws" {}

variables {
  # tf-label context inputs
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-specific required inputs
  topic_arn = "arn:aws:sns:us-east-1:123456789012:eg-test-thing-topic"
  protocol  = "sqs"
  endpoint  = "arn:aws:sqs:us-east-1:123456789012:eg-test-thing-queue"

  filter_policy = jsonencode({
    eventType = ["order_placed", "order_shipped"]
  })
}

# ---------------------------------------------------------------------------
# When enabled (default), the module creates exactly one subscription and the
# tf-label id resolves to the expected "namespace-stage-name" string.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing' for namespace=eg, stage=test, name=thing."
  }

  assert {
    condition     = length(aws_sns_topic_subscription.this) == 1
    error_message = "Exactly one aws_sns_topic_subscription should be planned when enabled."
  }

  assert {
    condition     = output.enabled == true
    error_message = "The 'enabled' output should be true by default."
  }

  assert {
    condition     = aws_sns_topic_subscription.this[0].protocol == "sqs"
    error_message = "The subscription protocol should pass through as 'sqs'."
  }
}

# ---------------------------------------------------------------------------
# When disabled, the module creates no resources and the arn/id outputs are
# null.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_sns_topic_subscription.this) == 0
    error_message = "No subscription should be planned when enabled = false."
  }

  assert {
    condition     = output.arn == null
    error_message = "The 'arn' output should be null when the module is disabled."
  }

  assert {
    condition     = output.id == null
    error_message = "The 'id' output should be null when the module is disabled."
  }

  assert {
    condition     = output.enabled == false
    error_message = "The 'enabled' output should be false when the module is disabled."
  }
}
