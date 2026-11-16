# WrittenProfileStatus

queued: the profile is being written. written: summary, statements and leads hold it. failed: it could not be written; error_code says why and no content is returned.

## Example Usage

```ruby
require "noresponse"

value = WrittenProfileStatus::QUEUED

# Open enum: use .deserialize() to create instances from custom string values
custom = WrittenProfileStatus.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `QUEUED`  | queued    |
| `WRITTEN` | written   |
| `FAILED`  | failed    |