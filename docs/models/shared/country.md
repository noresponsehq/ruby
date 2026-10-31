# Country

IP country, phone country, breach countries and policy_context.region together. When the breach records give a country, the timezone and locale countries count too. The IP country of a proxy or hosting network does not count.

## Example Usage

```ruby
require "noresponse"

value = Country::CONSISTENT

# Open enum: use .deserialize() to create instances from custom string values
custom = Country.deserialize("custom_value")
```


## Values

| Name         | Value        |
| ------------ | ------------ |
| `CONSISTENT` | consistent   |
| `MISMATCH`   | mismatch     |
| `UNKNOWN`    | unknown      |