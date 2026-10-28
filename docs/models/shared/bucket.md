# Bucket

The period each count covers, in UTC; a week starts on Monday.

## Example Usage

```ruby
require "noresponse"

value = Bucket::HOUR

# Open enum: use .deserialize() to create instances from custom string values
custom = Bucket.deserialize("custom_value")
```


## Values

| Name   | Value  |
| ------ | ------ |
| `HOUR` | hour   |
| `DAY`  | day    |
| `WEEK` | week   |