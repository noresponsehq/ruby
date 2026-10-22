# AssessmentRequestPolicyContext


## Fields

| Field                                                                   | Type                                                                    | Required                                                                | Description                                                             | Example                                                                 |
| ----------------------------------------------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `flow`                                                                  | [T.nilable(Models::Shared::Flow)](../../models/shared/flow.md)          | :heavy_minus_sign:                                                      | The provider flow the assessment gates. Absent means signup.            |                                                                         |
| `region`                                                                | *T.nilable(::String)*                                                   | :heavy_minus_sign:                                                      | ISO 3166-1 alpha-2 region of the signup, as the provider determines it. | AU                                                                      |