# SourceId

A NoResponse source: github (GitHub accounts), phone (the phone lookup), breach (breach exposure), rdap (the email domain's registration), mx (the email domain's mail servers), ipintel (IP intelligence) or an email account source that searches one platform for an account by email address (adobe, nvidia, wix, life360, zapier).

## Example Usage

```ruby
require "noresponse"

value = SourceId::GITHUB

# Open enum: use .deserialize() to create instances from custom string values
custom = SourceId.deserialize("custom_value")
```


## Values

| Name      | Value     |
| --------- | --------- |
| `GITHUB`  | github    |
| `PHONE`   | phone     |
| `BREACH`  | breach    |
| `RDAP`    | rdap      |
| `MX`      | mx        |
| `IPINTEL` | ipintel   |
| `ADOBE`   | adobe     |
| `NVIDIA`  | nvidia    |
| `WIX`     | wix       |
| `LIFE360` | life360   |
| `ZAPIER`  | zapier    |