# Provenance

Customer-submitted input. It does not mean the customer or NoResponse verified ownership.

## Example Usage

```ruby
require "noresponse"

value = Provenance::SUBMITTED

# Open enum: use .deserialize() to create instances from custom string values
custom = Provenance.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `SUBMITTED` | submitted   |