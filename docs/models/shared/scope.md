# Scope

## Example Usage

```ruby
require "noresponse"

value = Scope::ASSESS

# Open enum: use .deserialize() to create instances from custom string values
custom = Scope.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `ASSESS`       | assess         |
| `HISTORY`      | history        |
| `WEBHOOKS`     | webhooks       |
| `DETAILED`     | detailed       |
| `INTEGRATIONS` | integrations   |