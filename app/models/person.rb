class Person < ApplicationRecord
  has_one :d_master
  has_one :organizer

  validates :telegram_code, presence: true
end