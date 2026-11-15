# ListScreeningsRequest


## Fields

| Field                                | Type                                 | Required                             | Description                          | Example                              |
| ------------------------------------ | ------------------------------------ | ------------------------------------ | ------------------------------------ | ------------------------------------ |
| `group_id`                           | *::String*                           | :heavy_check_mark:                   | N/A                                  | grp_01JA2Z8K6Q4V7W9XBCDEFGHJKM       |
| `limit`                              | *T.nilable(::Integer)*               | :heavy_minus_sign:                   | At most this many items.             |                                      |
| `before`                             | *T.nilable(::String)*                | :heavy_minus_sign:                   | Read screenings older than this one. |                                      |