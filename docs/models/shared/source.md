# Source

## Example Usage

```ruby
require "noresponse"

value = Source::REQUESTS

# Open enum: use .deserialize() to create instances from custom string values
custom = Source.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `REQUESTS`         | requests           |
| `WEBHOOK_ATTEMPTS` | webhook_attempts   |