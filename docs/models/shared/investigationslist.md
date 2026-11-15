# InvestigationsList

List investigation history.


## Fields

| Field                                                                           | Type                                                                            | Required                                                                        | Description                                                                     | Example                                                                         |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `items`                                                                         | T::Array<[Models::Shared::Investigation](../../models/shared/investigation.md)> | :heavy_check_mark:                                                              | N/A                                                                             |                                                                                 |
| `has_more`                                                                      | *T::Boolean*                                                                    | :heavy_check_mark:                                                              | N/A                                                                             |                                                                                 |
| `next_cursor`                                                                   | *T.nilable(::String)*                                                           | :heavy_check_mark:                                                              | N/A                                                                             | inv_01JA2Z8K6Q4V7W9XBCDEFGHJKM                                                  |