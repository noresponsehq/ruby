# UsageCountFlow

assessments only.

## Example Usage

```ruby
require "noresponse"

value = UsageCountFlow::ACCOUNT_CREATION

# Open enum: use .deserialize() to create instances from custom string values
custom = UsageCountFlow.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `ACCOUNT_CREATION` | account_creation   |
| `LOGIN`            | login              |
| `PURCHASE`         | purchase           |