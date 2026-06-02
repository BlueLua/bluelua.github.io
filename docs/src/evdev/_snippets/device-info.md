| Key            | Type        | Description                         |
| -------------- | ----------- | ----------------------------------- |
| `path`         | `string`    | Device path                         |
| `name`         | `string?`   | Human-readable name                 |
| `bustype`      | `integer`   | Bus type identifier                 |
| `vendor`       | `integer`   | Vendor ID                           |
| `product`      | `integer`   | Product ID                          |
| `version`      | `integer`   | Device version                      |
| `phys`         | `string?`   | Physical location                   |
| `uniq`         | `string?`   | Unique identifier                   |
| `id_aliases`   | `string[]?` | Symlinks under `/dev/input/by-id`   |
| `path_aliases` | `string[]?` | Symlinks under `/dev/input/by-path` |
