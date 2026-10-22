# ResponseMode

standard returns the consolidated risk response; detailed adds merged provider-neutral facts when the key has detailed scope. There is no raw mode.

## Example Usage

```ruby
require "noresponse"

value = ResponseMode::STANDARD

# Open enum: use .deserialize() to create instances from custom string values
custom = ResponseMode.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `STANDARD` | standard   |
| `DETAILED` | detailed   |