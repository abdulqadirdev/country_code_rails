json.extract! user, :id, :name, :email, :phone, :country, :state, :city, :created_at, :updated_at
json.url user_url(user, format: :json)
