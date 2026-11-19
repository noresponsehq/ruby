# Stage

ai_typing and analysis appear only on searches recorded before the engine stopped analysing results.

## Example Usage

```ruby
require "noresponse"

value = Stage::LOOKUP

# Open enum: use .deserialize() to create instances from custom string values
custom = Stage.deserialize("custom_value")
```


## Values

| Name             | Value            |
| ---------------- | ---------------- |
| `LOOKUP`         | lookup           |
| `LOOKUP_TYPING`  | lookup_typing    |
| `PLATFORMS`      | platforms        |
| `WRITTEN`        | written          |
| `LATE_PLATFORMS` | late_platforms   |
| `LATE_LOOKUP`    | late_lookup      |
| `AI_TYPING`      | ai_typing        |
| `ANALYSIS`       | analysis         |
| `RATING`         | rating           |