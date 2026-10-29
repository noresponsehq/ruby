# ReviewStatus

## Example Usage

```ruby
require "noresponse"

value = ReviewStatus::OPEN

# Open enum: use .deserialize() to create instances from custom string values
custom = ReviewStatus.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `OPEN`        | open          |
| `IN_PROGRESS` | in_progress   |
| `RESOLVED`    | resolved      |