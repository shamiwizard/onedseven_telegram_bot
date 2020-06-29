require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBots::OrganizerTelegramBotController, telegram_bot: :rails do
  let(:bot) { Telegram.bots[:organizers] }
  let(:bot_d_master) { Telegram.bots[:masters] }
  let(:d_master) { create(:d_master) }
  let(:organizer) { create(:organizer) }
  let(:from) { attributes_for(:person_params) }

  after { Telegram.bots.each_value(&:reset) }

  describe '#start!' do
    subject(:start!) { dispatch_command(:start) }

    context "when person doesn't have role organizer" do
      it 'return message' do
        expect { start! }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: 'Hello organizer now you can run poll fot DM only on command /poll'))
      end

      it 'update role to organizer' do
        expect { start! }.to change(Organizer, :count)
      end

      it 'update role for right person' do
        start!
        expect(Organizer.last.person.telegram_code.to_i).to eq(from[:id])
      end
    end

    context 'when person have role organizer' do
      before { from[:id] = organizer.person.telegram_code }

      it 'return message' do
        expect { start! }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: 'Hello organizer now you can run poll fot DM only on command /poll'))
      end

      it 'update person role to organize' do
        expect { start! }.not_to change(Organizer, :count)
      end
    end
  end

  describe '#start_poll' do
    subject(:start_poll!) { dispatch_command(:start_poll) }

    context 'when person is organizer' do
      before { from[:id] = organizer.person.telegram_code }

      it 'create poll' do
        expect { start_poll! }.to change(Poll, :count)
      end

      it 'send message to dungens masters' do
        d_master
        expect { start_poll! }.to make_telegram_request(bot_d_master, :sendMessage)
          .with(hash_including(text: 'Poll started could you vote)\n Write /yes or /no if you can'))
      end
    end
  end
end