# CustomerExportStatus

## Example Usage

```ruby
require "noresponse"

value = CustomerExportStatus::QUEUED

# Open enum: use .deserialize() to create instances from custom string values
custom = CustomerExportStatus.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `QUEUED`    | queued      |
| `RUNNING`   | running     |
| `COMPLETED` | completed   |
| `FAILED`    | failed      |
| `CANCELLED` | cancelled   |
| `EXPIRED`   | expired     |