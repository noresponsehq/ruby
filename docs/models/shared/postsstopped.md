# PostsStopped

Why fewer posts were read than the screening's depth asks for while the account holds more. platform_limit: the platform shows the screening no more of them. page_limit: the pages a screening reads ran out first. rate_limited or unavailable: a later page was held back or failed; the posts before it are kept and the person is partial. Absent when the account was read to its end or to the depth.

## Example Usage

```ruby
require "noresponse"

value = PostsStopped::PLATFORM_LIMIT

# Open enum: use .deserialize() to create instances from custom string values
custom = PostsStopped.deserialize("custom_value")
```


## Values

| Name             | Value            |
| ---------------- | ---------------- |
| `PLATFORM_LIMIT` | platform_limit   |
| `PAGE_LIMIT`     | page_limit       |
| `RATE_LIMITED`   | rate_limited     |
| `UNAVAILABLE`    | unavailable      |