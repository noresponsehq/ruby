# Flow

The customer event an assessment is made for: signup (a new account), login (a returning sign-in) or purchase (a payment or credit grant). The account's risk is reported with the decision for this flow.

## Example Usage

```ruby
require "noresponse"

value = Flow::SIGNUP

# Open enum: use .deserialize() to create instances from custom string values
custom = Flow.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `SIGNUP`   | signup     |
| `LOGIN`    | login      |
| `PURCHASE` | purchase   |