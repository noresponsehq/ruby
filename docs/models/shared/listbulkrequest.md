# ListBulkRequest

At most 100 additions and removals combined. One transaction applies all changes or none. Idempotency-Key prevents duplicate changes for 24 hours; a different body under the same key returns 409. Matching reads see the new list immediately, while bounded durable jobs propagate account risk notifications.


## Fields

| Field                                                                                 | Type                                                                                  | Required                                                                              | Description                                                                           |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `add`                                                                                 | T::Array<[Models::Shared::ListEntryRequest](../../models/shared/listentryrequest.md)> | :heavy_minus_sign:                                                                    | N/A                                                                                   |
| `remove`                                                                              | T::Array<*::String*>                                                                  | :heavy_minus_sign:                                                                    | N/A                                                                                   |