# Topic

## Example Usage

```ruby
require "noresponse"

value = Topic::IDENTITY

# Open enum: use .deserialize() to create instances from custom string values
custom = Topic.deserialize("custom_value")
```


## Values

| Name            | Value           |
| --------------- | --------------- |
| `IDENTITY`      | identity        |
| `LOCATION`      | location        |
| `MOVEMENT`      | movement        |
| `TIMELINE`      | timeline        |
| `INTERESTS`     | interests       |
| `RELATIONSHIPS` | relationships   |
| `WORK`          | work            |
| `EDUCATION`     | education       |
| `ACCOUNTS`      | accounts        |
| `CREDENTIALS`   | credentials     |
| `DEVICES`       | devices         |
| `ABSENCE`       | absence         |