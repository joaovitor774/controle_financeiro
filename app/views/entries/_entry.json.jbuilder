json.extract! entry, :id, :description, :amount, :occurred_on, :created_at, :updated_at
json.url entry_url(entry, format: :json)
