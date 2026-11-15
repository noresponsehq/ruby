# SearchKind

The kind of the value searched. A domain search finds the leaked rows of every email address at the domain.

## Example Usage

```ruby
require "noresponse"

value = SearchKind::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = SearchKind.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `EMAIL`       | email         |
| `PHONE`       | phone         |
| `USERNAME`    | username      |
| `PERSON_NAME` | person_name   |
| `PASSWORD`    | password      |
| `HASH`        | hash          |
| `IP`          | ip            |
| `DOMAIN`      | domain        |