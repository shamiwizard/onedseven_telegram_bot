class Person < ApplicationRecord
  PERSON_TYPE = {
    dmaster: 'Dungeon Master',
    organizer: 'Organizer'
  }

  enum person_type: PERSON_TYPE

  validates :telegram_code, presence: true

  def dmaster?
    self.person_type == 'dmaster'
  end

  def organizer?
    self.person_type == 'organizer'
  end
end