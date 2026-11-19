# RecordConflictSignal

anchors_disagree: records found by two of the identifiers you gave clash with each other, so those identifiers may belong to different people.

## Example Usage

```ruby
require "noresponse"

value = RecordConflictSignal::ANCHORS_DISAGREE

# Open enum: use .deserialize() to create instances from custom string values
custom = RecordConflictSignal.deserialize("custom_value")
```


## Values

| Name               | Value              |
| ------------------ | ------------------ |
| `ANCHORS_DISAGREE` | anchors_disagree   |