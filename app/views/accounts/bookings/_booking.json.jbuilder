json.extract! booking, :id, :title, :description, :scheduled_at, :duration_minutes, :status, :created_at, :updated_at
json.url booking_url(booking, format: :json)
