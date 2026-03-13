class EntryStatus < ApplicationRecord
  has_many :entries, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
