class Account < ApplicationRecord
  belongs_to :user
  belongs_to :account_type

  has_many :entries, dependent: :restrict_with_exception

  validates :name, presence: true
end