# OwnerType

The credential namespace of the creator. An external user ID equal to an API-key label does not grant ownership of that key's private view.

## Example Usage

```ruby
require "noresponse"

value = OwnerType::USER

# Open enum: use .deserialize() to create instances from custom string values
custom = OwnerType.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `USER`    | user      |
| `API_KEY` | api_key   |