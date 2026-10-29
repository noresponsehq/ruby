# Metric

assessments: assessments admitted. webhook_deliveries: events sent to endpoints, one per event per endpoint. key_usage_events: key-usage events accepted.

## Example Usage

```ruby
require "noresponse"

value = Metric::ASSESSMENTS

# Open enum: use .deserialize() to create instances from custom string values
custom = Metric.deserialize("custom_value")
```


## Values

| Name                 | Value                |
| -------------------- | -------------------- |
| `ASSESSMENTS`        | assessments          |
| `WEBHOOK_DELIVERIES` | webhook_deliveries   |
| `KEY_USAGE_EVENTS`   | key_usage_events     |