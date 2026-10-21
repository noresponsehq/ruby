# IncompleteReason

Why a lane did not settle. deferred means the lane is asynchronous and still running; a continuation settles it. timed_out means the lane missed its deadline. insufficient_evidence is a settled inconclusive signal rather than an incomplete lane.

## Example Usage

```ruby
require "noresponse"

value = IncompleteReason::TIMED_OUT

# Open enum: use .deserialize() to create instances from custom string values
custom = IncompleteReason.deserialize("custom_value")
```


## Values

| Name           | Value          |
| -------------- | -------------- |
| `TIMED_OUT`    | timed_out      |
| `RATE_LIMITED` | rate_limited   |
| `BLOCKED`      | blocked        |
| `SOURCE_ERROR` | source_error   |
| `UNAVAILABLE`  | unavailable    |
| `DEFERRED`     | deferred       |