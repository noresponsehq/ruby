# KeyScope

## Example Usage

```ruby
require "noresponse"

value = KeyScope::ASSESS

# Open enum: use .deserialize() to create instances from custom string values
custom = KeyScope.deserialize("custom_value")
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