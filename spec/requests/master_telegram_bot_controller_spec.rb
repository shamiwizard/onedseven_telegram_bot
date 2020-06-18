require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBots::MasterTelegramBotController, telegram_bot: :rails do
  after { Telegram.bots.each_value(&:reset) }
  let(:bot) { Telegram.bots[:masters] }
  let!(:person) { create(:person) }

  describe '#dmaster!' do
    before { from[:id] = person.telegram_code }

    subject { dispatch_command(:dmaster) }

    context 'when person already has role' do
      context 'when person role is master' do
        before { DMaster.create(person_id: person.id) }

        xit 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "You can't update your role because your role is already Dungeon master"))
        end

        xit "not create new record" do
          expect { subject }.to_not change { DMaster.count }
        end
      end
    end

    context 'when peson hasn\'t role' do
      xit 'retrun message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Congratelate now your role is Dungeon master"))
      end

      xit "create new record" do
        expect { subject }.to change { DMaster.count }
      end
    end
  end

  describe '#organizer!' do
    before do
      from[:id] = person.telegram_code
    end

    subject { dispatch_command(:organizer) }

    context 'when person already has role' do
      context 'when person role is organizer' do
        before { Organizer.create(person_id: person.id) }

        xit 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "You can't update your role because your role is already Organizer"))
        end

        xit 'not create new record' do
          expect { subject }.to_not change{ Organizer.count }
        end
      end
    end

    context 'when peson hasn\'t role' do
      xit 'retrun message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Congratelate now your role is Organizer"))
      end

      xit 'create new record' do
        expect { subject }.to change { Organizer.count }
      end
    end
  end
end