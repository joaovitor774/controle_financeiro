class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :category
  belongs_to :entry_type
  belongs_to :entry_status

  validates :description, presence: true
  validates :amount, presence: true
  validates :occurred_on, presence: true
end