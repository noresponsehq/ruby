# Flow

The event an assessment is made for: account_creation (a user creates an account), login (a user returns to an existing account) or purchase (a payment or a credit grant). The account's risk is reported with the decision for this flow.

## Example Usage

```ruby
require "noresponse"

value = Flow::ACCOUNT_CREATION

# Open enum: use .deserialize() to create instances from custom string values
custom = Flow.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `ACCOUNT_CREATION` | account_creation   |
| `LOGIN`            | login              |
| `PURCHASE`         | purchase           |