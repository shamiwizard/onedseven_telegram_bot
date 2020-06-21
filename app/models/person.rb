class Person < ApplicationRecord
  has_one :d_master, dependent: destroy
  has_one :organizer, dependent: destroy

  validates :telegram_code, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end