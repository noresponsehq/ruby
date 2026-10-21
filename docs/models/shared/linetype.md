# LineType

## Example Usage

```ruby
require "noresponse"

value = LineType::MOBILE

# Open enum: use .deserialize() to create instances from custom string values
custom = LineType.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `MOBILE`    | mobile      |
| `VOIP`      | voip        |
| `LANDLINE`  | landline    |
| `TOLL_FREE` | toll_free   |
| `OTHER`     | other       |