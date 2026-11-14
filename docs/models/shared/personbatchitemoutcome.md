# PersonBatchItemOutcome

unchanged: the row matched a person with the same details.

## Example Usage

```ruby
require "noresponse"

value = PersonBatchItemOutcome::CREATED

# Open enum: use .deserialize() to create instances from custom string values
custom = PersonBatchItemOutcome.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CREATED`   | created     |
| `UPDATED`   | updated     |
| `UNCHANGED` | unchanged   |