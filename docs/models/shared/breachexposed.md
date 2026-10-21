# BreachExposed

The kind of data a breach table held beside the identifier. password means a plaintext password was present and password_hash means a hash, salt or token was present. The value itself is not stored or returned; the schema has no member for one.

## Example Usage

```ruby
require "noresponse"

value = BreachExposed::EMAIL

# Open enum: use .deserialize() to create instances from custom string values
custom = BreachExposed.deserialize("custom_value")
```


## Values

| Name            | Value           |
| --------------- | --------------- |
| `EMAIL`         | email           |
| `USERNAME`      | username        |
| `NAME`          | name            |
| `PASSWORD`      | password        |
| `PASSWORD_HASH` | password_hash   |
| `PHONE`         | phone           |
| `ADDRESS`       | address         |
| `DOB`           | dob             |
| `IP`            | ip              |
| `PAYMENT`       | payment         |
| `SECURITY_QA`   | security_qa     |