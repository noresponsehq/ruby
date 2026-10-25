# DefaultDepth

The depth a request for this flow that names none is served at. Defaults: full for account_creation and purchase, quick for login.

## Example Usage

```ruby
require "noresponse"

value = DefaultDepth::QUICK

# Open enum: use .deserialize() to create instances from custom string values
custom = DefaultDepth.deserialize("custom_value")
```


## Values

| Name    | Value   |
| ------- | ------- |
| `QUICK` | quick   |
| `FULL`  | full    |