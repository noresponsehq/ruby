# KeyRotationScope

## Example Usage

```ruby
require "noresponse"

value = KeyRotationScope::ASSESS

# Open enum: use .deserialize() to create instances from custom string values
custom = KeyRotationScope.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `ASSESS`       | assess         |
| `HISTORY`      | history        |
| `DELETE`       | delete         |
| `WEBHOOKS`     | webhooks       |
| `DETAILED`     | detailed       |
| `INTEGRATIONS` | integrations   |
| `MANAGEMENT`   | management     |