json.extract! client, :id, :name, :email, :phone, :company, :notes, :created_at, :updated_at
json.url client_url(client, format: :json)
