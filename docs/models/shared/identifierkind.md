# IdentifierKind

Which submitted identifier a signal concerns. ip is a selector of breach_exposure only.

## Example Usage

```ruby
require "noresponse"

value = IdentifierKind::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = IdentifierKind.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `EMAIL`    | email      |
| `USERNAME` | username   |
| `PHONE`    | phone      |
| `IP`       | ip         |