class Organizer < ApplicationRecord
  belongs_to :person
  has_many :poll

  validates :person_id, presence: true
end
