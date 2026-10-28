# AssessmentAggregateMetric

## Example Usage

```ruby
require "noresponse"

value = AssessmentAggregateMetric::COUNT

# Open enum: use .deserialize() to create instances from custom string values
custom = AssessmentAggregateMetric.deserialize("custom_value")
```


## Values

| Name              | Value             |
| ----------------- | ----------------- |
| `COUNT`           | count             |
| `SCORE_HISTOGRAM` | score_histogram   |
| `LATE_FLIPS`      | late_flips        |