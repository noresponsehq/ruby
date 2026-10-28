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
| `SCORE_OUTCOMES`  | score_outcomes    |
| `LATE_FLIPS`      | late_flips        |