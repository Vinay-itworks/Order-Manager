json.extract! address, :id, :user_id, :address_type, :address, :city, :state, :country, :zipcode, :is_active, :created_at, :updated_at
json.url address_url(address, format: :json)
