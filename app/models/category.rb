class Category < ApplicationRecord
  belongs_to :user
  belongs_to :category_kind

  has_many :entries, dependent: :restrict_with_exception

  validates :name, presence: true
end