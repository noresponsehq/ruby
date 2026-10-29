# OperationalAggregateQueue

Current retained delivery queue, independent of the requested attempt window and status filter. Endpoint filter applies. Does not prove customer enforcement execution.


## Fields

| Field                 | Type                  | Required              | Description           | Example               |
| --------------------- | --------------------- | --------------------- | --------------------- | --------------------- |
| `pending`             | *::Integer*           | :heavy_check_mark:    | N/A                   |                       |
| `leased`              | *::Integer*           | :heavy_check_mark:    | N/A                   |                       |
| `dead_retained`       | *::Integer*           | :heavy_check_mark:    | N/A                   |                       |
| `oldest_pending_at`   | *T.nilable(::String)* | :heavy_minus_sign:    | N/A                   | 2026-01-01T00:00:00Z  |