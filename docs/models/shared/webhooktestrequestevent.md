# WebhookTestRequestEvent

endpoint.verification sends a fresh challenge now, in this call, and the endpoint is verified if it echoes it. assessment.updated queues an event whose data is a fixed example assessment, with test true, delivered and retried like any other; the endpoint must be verified.

## Example Usage

```ruby
require "noresponse"

value = WebhookTestRequestEvent::ENDPOINT_VERIFICATION

# Open enum: use .deserialize() to create instances from custom string values
custom = WebhookTestRequestEvent.deserialize("custom_value")
```


## Values

| Name                    | Value                   |
| ----------------------- | ----------------------- |
| `ENDPOINT_VERIFICATION` | endpoint.verification   |
| `ASSESSMENT_UPDATED`    | assessment.updated      |