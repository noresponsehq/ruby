# Attribute

name_gender is the records' gender against the submitted first name's usual one.

## Example Usage

```ruby
require "noresponse"

value = Attribute::BIRTH_DATE

# Open enum: use .deserialize() to create instances from custom string values
custom = Attribute.deserialize("custom_value")
```


## Values

| Name          | Value         |
| ------------- | ------------- |
| `BIRTH_DATE`  | birth_date    |
| `GENDER`      | gender        |
| `NATIONALITY` | nationality   |
| `NAME_GENDER` | name_gender   |