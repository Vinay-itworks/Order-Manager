json.extract! product, :id, :name, :description, :price, :discount, :compare_at_price, :is_active, :created_at, :updated_at
json.url product_url(product, format: :json)
