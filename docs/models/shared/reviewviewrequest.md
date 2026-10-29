# ReviewViewRequest


## Fields

| Field                                                   | Type                                                    | Required                                                | Description                                             | Example                                                 |
| ------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------- |
| `name`                                                  | *::String*                                              | :heavy_check_mark:                                      | N/A                                                     | High priority reviews                                   |
| `shared`                                                | *T::Boolean*                                            | :heavy_check_mark:                                      | N/A                                                     |                                                         |
| `expected_version`                                      | *T.nilable(::Integer)*                                  | :heavy_minus_sign:                                      | N/A                                                     |                                                         |
| `filter`                                                | [Models::Shared::Filter](../../models/shared/filter.md) | :heavy_check_mark:                                      | N/A                                                     |                                                         |