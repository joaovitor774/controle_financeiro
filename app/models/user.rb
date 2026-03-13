class User < ApplicationRecord
  has_secure_password
  
  has_many :accounts, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :entries, dependent: :destroy
end
