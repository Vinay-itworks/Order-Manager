json.extract! photo, :id, :photo, :photoable_id, :photoable_type, :created_at, :updated_at
json.url photo_url(photo, format: :json)
json.photo url_for(photo.photo)
