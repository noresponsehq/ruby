# ScreeningSpend

What screening cost, in US cents, in total and per implementation.


## Fields

| Field                                                                                     | Type                                                                                      | Required                                                                                  | Description                                                                               |
| ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| `total_minor`                                                                             | *::Integer*                                                                               | :heavy_check_mark:                                                                        | The total, in US cents.                                                                   |
| `by_implementation`                                                                       | T::Array<[Models::Shared::ScreeningSpendLine](../../models/shared/screeningspendline.md)> | :heavy_check_mark:                                                                        | N/A                                                                                       |