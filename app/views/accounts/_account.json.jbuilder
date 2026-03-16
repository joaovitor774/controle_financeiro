json.extract! account, :id, :name, :initial_balance, :active, :account_type_id, :created_at, :updated_at
json.url account_url(account, format: :json)
