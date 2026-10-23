# AssessmentFlow

The customer event an assessment is made for: signup (a new account), login (a returning sign-in) or purchase (a payment or credit grant). The account's risk is reported with the decision for this flow.

## Example Usage

```ruby
require "noresponse"

value = AssessmentFlow::SIGNUP
```


## Values

| Name       | Value      |
| ---------- | ---------- |
| `SIGNUP`   | signup     |
| `LOGIN`    | login      |
| `PURCHASE` | purchase   |