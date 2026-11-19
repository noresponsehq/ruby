# SchedulePeriod

How often the person is investigated again: daily, weekly or monthly, counted from when the schedule was set; off runs no scheduled investigation.

## Example Usage

```ruby
require "noresponse"

value = SchedulePeriod::DAILY

# Open enum: use .deserialize() to create instances from custom string values
custom = SchedulePeriod.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `DAILY`   | daily     |
| `WEEKLY`  | weekly    |
| `MONTHLY` | monthly   |
| `OFF`     | off       |