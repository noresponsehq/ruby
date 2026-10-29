# AggregateGroupListMatch

The list action captured with the first answer. none means no matching entry was found. For retained_first_answers an absent field means the older assessment did not capture list state; this remains a separate group.

## Example Usage

```ruby
require "noresponse"

value = AggregateGroupListMatch::BLOCK

# Open enum: use .deserialize() to create instances from custom string values
custom = AggregateGroupListMatch.deserialize("custom_value")
```


## Values

| Name    | Value   |
| ------- | ------- |
| `BLOCK` | block   |
| `ALLOW` | allow   |
| `NONE`  | none    |