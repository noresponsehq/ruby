# Population

first_answers uses anonymous counters that can include erased detail. retained_first_answers computes exact intersections over retained first answers within 31 days. Requests exceeding the 100000-record work budget are refused.

## Example Usage

```ruby
require "noresponse"

value = Population::FIRST_ANSWERS

# Open enum: use .deserialize() to create instances from custom string values
custom = Population.deserialize("custom_value")
```


## Values

| Name                     | Value                    |
| ------------------------ | ------------------------ |
| `FIRST_ANSWERS`          | first_answers            |
| `RETAINED_FIRST_ANSWERS` | retained_first_answers   |