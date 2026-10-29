# Namespace

Required for username: the username submitted by this customer in this workspace/environment. It does not name or join a source platform. Omit for email and phone.

## Example Usage

```ruby
require "noresponse"

value = Namespace::CUSTOMER

# Open enum: use .deserialize() to create instances from custom string values
custom = Namespace.deserialize("custom_value")
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `CUSTOMER` | customer   |