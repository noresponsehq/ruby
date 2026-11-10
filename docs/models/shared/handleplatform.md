# HandlePlatform

A platform a screening can cover. synthetic is the deterministic connector's own platform, for exercising the product end to end with no network.

## Example Usage

```ruby
require "noresponse"

value = HandlePlatform::INSTAGRAM

# Open enum: use .deserialize() to create instances from custom string values
custom = HandlePlatform.deserialize("custom_value")
```


## Values

| Name        | Value       |
| ----------- | ----------- |
| `INSTAGRAM` | instagram   |
| `X`         | x           |
| `BLUESKY`   | bluesky     |
| `YOUTUBE`   | youtube     |
| `TIKTOK`    | tiktok      |
| `FACEBOOK`  | facebook    |
| `THREADS`   | threads     |
| `REDDIT`    | reddit      |
| `TELEGRAM`  | telegram    |
| `LINKEDIN`  | linkedin    |
| `SYNTHETIC` | synthetic   |