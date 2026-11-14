# Verdict

A reviewer's overrule (POST .../people/{person_id}/records), which decides joined whatever the likelihood and sticks for as long as a lookup finds the same record. Absent when nobody overruled it.

## Example Usage

```ruby
require "noresponse"

value = Verdict::JOINED

# Open enum: use .deserialize() to create instances from custom string values
custom = Verdict.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `JOINED`   | joined     |
| `REJECTED` | rejected   |