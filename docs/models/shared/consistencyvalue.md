# ConsistencyValue

How a submitted identifier agrees with what the evidence holds for the other identifiers. unknown is a definite 'cannot tell' (for example a truncated or too-common breach result); absent means the comparison was not made.

## Example Usage

```ruby
require "noresponse"

value = ConsistencyValue::MATCH

# Open enum: use .deserialize() to create instances from custom string values
custom = ConsistencyValue.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `MATCH`    | match      |
| `PARTIAL`  | partial    |
| `MISMATCH` | mismatch   |
| `UNKNOWN`  | unknown    |