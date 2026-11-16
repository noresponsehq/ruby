# Basis

stated: read from a record. inferred: reasoned from several facts. absence: every source answered and none found it.

## Example Usage

```ruby
require "noresponse"

value = Basis::STATED

# Open enum: use .deserialize() to create instances from custom string values
custom = Basis.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `STATED`   | stated     |
| `INFERRED` | inferred   |
| `ABSENCE`  | absence    |