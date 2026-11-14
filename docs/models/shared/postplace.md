# PostPlace

A place a post names, as the platform shows it.


## Fields

| Field                               | Type                                | Required                            | Description                         | Example                             |
| ----------------------------------- | ----------------------------------- | ----------------------------------- | ----------------------------------- | ----------------------------------- |
| `name`                              | *::String*                          | :heavy_check_mark:                  | N/A                                 | Example Harbour                     |
| `id`                                | *T.nilable(::String)*               | :heavy_minus_sign:                  | The platform's own id of the place. | 212988663                           |
| `address`                           | *T.nilable(::String)*               | :heavy_minus_sign:                  | N/A                                 | 2 Wharf Road                        |
| `city`                              | *T.nilable(::String)*               | :heavy_minus_sign:                  | N/A                                 | Melbourne                           |
| `latitude`                          | *T.nilable(::Float)*                | :heavy_minus_sign:                  | N/A                                 |                                     |
| `longitude`                         | *T.nilable(::Float)*                | :heavy_minus_sign:                  | N/A                                 |                                     |