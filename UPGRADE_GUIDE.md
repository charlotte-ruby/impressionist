# Upgrade guide

## v1.5.1 -> v1.5.2

Version 1.5.2 adds are new column to the `impressions` table. If you're on v1.5.1 you need to manually add the new column using

```
add_column :impressions, :params, :text

add_index :impressions, [:impressionable_type, :impressionable_id, :params], :name => "poly_params_request_index", :unique => false
```

before upgrading.
