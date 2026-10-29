# ErasureReceiptTargetName

## Example Usage

```ruby
require "noresponse"

value = ErasureReceiptTargetName::SERVING

# Open enum: use .deserialize() to create instances from custom string values
custom = ErasureReceiptTargetName.deserialize("custom_value")
```


## Values

| Name                    | Value                   |
| ----------------------- | ----------------------- |
| `SERVING`               | serving                 |
| `OUTBOX`                | outbox                  |
| `CACHE`                 | cache                   |
| `DOWNSTREAM_PROJECTION` | downstream_projection   |