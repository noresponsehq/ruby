# WebhookEndpointState

unverified until the endpoint echoes an endpoint.verification challenge (send one with POST /v1/webhooks/{endpoint_id}/test); verified receives assessment.updated events; disabled after 72 hours of continuous delivery failure, and verified again by the same challenge.

## Example Usage

```ruby
require "noresponse"

value = WebhookEndpointState::UNVERIFIED

# Open enum: use .deserialize() to create instances from custom string values
custom = WebhookEndpointState.deserialize("custom_value")
```


## Values

| Name         | Value        |
| ------------ | ------------ |
| `UNVERIFIED` | unverified   |
| `VERIFIED`   | verified     |
| `DISABLED`   | disabled     |