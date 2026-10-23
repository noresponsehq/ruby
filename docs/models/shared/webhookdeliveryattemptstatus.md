# WebhookDeliveryAttemptStatus

delivered when the endpoint answered 2xx; failed otherwise, with failure naming why.

## Example Usage

```ruby
require "noresponse"

value = WebhookDeliveryAttemptStatus::DELIVERED

# Open enum: use .deserialize() to create instances from custom string values
custom = WebhookDeliveryAttemptStatus.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `DELIVERED` | delivered   |
| `FAILED`    | failed      |