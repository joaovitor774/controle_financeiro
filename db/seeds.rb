# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
account_types = %w[checking savings credit_card cash]
category_kinds = %w[income expense]
entry_types = %w[income expense]
entry_statuses = %w[pending paid canceled]

account_types.each do |name|
  AccountType.find_or_create_by!(name: name)
end

category_kinds.each do |name|
  CategoryKind.find_or_create_by!(name: name)
end

entry_types.each do |name|
  EntryType.find_or_create_by!(name: name)
end

entry_statuses.each do |name|
  EntryStatus.find_or_create_by!(name: name)
end