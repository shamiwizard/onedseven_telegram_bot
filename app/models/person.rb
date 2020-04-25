class Person < ApplicationRecord
  validates :telegram_code, presence: true
end