# Agreement

## Example Usage

```ruby
require "noresponse"

value = Agreement::MATCH

# Open enum: use .deserialize() to create instances from custom string values
custom = Agreement.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `MATCH`    | match      |
| `PARTIAL`  | partial    |
| `MISMATCH` | mismatch   |