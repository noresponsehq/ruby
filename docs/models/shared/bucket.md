# Bucket

The period each count covers: an hour, or a day or a week (from Monday) in time_zone. Hour buckets are whole UTC hours in any time zone.

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