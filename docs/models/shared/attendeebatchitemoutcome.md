# AttendeeBatchItemOutcome

unchanged: the row matched an attendee with the same details.

## Example Usage

```ruby
require "noresponse"

value = AttendeeBatchItemOutcome::CREATED

# Open enum: use .deserialize() to create instances from custom string values
custom = AttendeeBatchItemOutcome.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `CREATED`   | created     |
| `UPDATED`   | updated     |
| `UNCHANGED` | unchanged   |