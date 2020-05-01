class Person < ApplicationRecord
  PERSON_TYPE = {
    dmaster: 'Dungeon Master',
    organizer: 'Organizer'
  }

  enum person_type: PERSON_TYPE

  validates :telegram_code, presence: true
end