json.extract! order, :id, :users_id, :addresses_id, :products_id, :order_price, :created_at, :updated_at
json.url order_url(order, format: :json)
