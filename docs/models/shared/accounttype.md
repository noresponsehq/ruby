# AccountType

personal, or business: an account a company or school manages.

## Example Usage

```ruby
require "noresponse"

value = AccountType::PERSONAL

# Open enum: use .deserialize() to create instances from custom string values
custom = AccountType.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `PERSONAL` | personal   |
| `BUSINESS` | business   |