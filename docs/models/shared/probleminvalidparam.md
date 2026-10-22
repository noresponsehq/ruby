# ProblemInvalidParam


## Fields

| Field                                                | Type                                                 | Required                                             | Description                                          | Example                                              |
| ---------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------- | ---------------------------------------------------- |
| `field`                                              | *::String*                                           | :heavy_check_mark:                                   | N/A                                                  | identifiers                                          |
| `reason`                                             | *::String*                                           | :heavy_check_mark:                                   | N/A                                                  | at least one of email, username or phone is required |
| `example`                                            | *T.nilable(::String)*                                | :heavy_minus_sign:                                   | N/A                                                  | new.user@example.com                                 |