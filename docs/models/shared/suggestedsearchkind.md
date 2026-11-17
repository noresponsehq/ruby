# SuggestedSearchKind

The kind of the value: one of the kinds the environment's enrichment setting names.

## Example Usage

```ruby
require "noresponse"

value = SuggestedSearchKind::USERNAME

# Open enum: use .deserialize() to create instances from custom string values
custom = SuggestedSearchKind.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `USERNAME` | username   |
| `EMAIL`    | email      |
| `PHONE`    | phone      |