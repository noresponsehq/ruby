# OutcomesByOutcome

Current customer-reported labels, not independently established ground truth. Missing keys mean zero. Unknown is an explicit report; absent or expired feedback is unreported.


## Fields

| Field                  | Type                   | Required               | Description            |
| ---------------------- | ---------------------- | ---------------------- | ---------------------- |
| `confirmed_abuse`      | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |
| `account_takeover`     | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |
| `chargeback`           | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |
| `false_positive`       | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |
| `legitimate`           | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |
| `unknown`              | *T.nilable(::Integer)* | :heavy_minus_sign:     | N/A                    |