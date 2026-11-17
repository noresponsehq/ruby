# EnrichmentKind

## Example Usage

```ruby
require "noresponse"

value = EnrichmentKind::USERNAME

# Open enum: use .deserialize() to create instances from custom string values
custom = EnrichmentKind.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `USERNAME` | username   |
| `EMAIL`    | email      |
| `PHONE`    | phone      |