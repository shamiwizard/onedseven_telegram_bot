require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '#full_name' do
    let(:person) { create(:person) }

    it 'return person full name' do
      expect(person.full_name).to eq("#{person.first_name} #{person.last_name}")
    end
  end
end
