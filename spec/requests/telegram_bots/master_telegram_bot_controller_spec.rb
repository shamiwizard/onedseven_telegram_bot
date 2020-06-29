require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBots::MasterTelegramBotController, telegram_bot: :rails do
  let(:bot) { Telegram.bots[:masters] }

  after { Telegram.bots.each_value(&:reset) }

  describe '#start!' do
    subject(:start!) { dispatch_command(:start) }

    let(:from) { attributes_for(:person_params) }

    context "when person doesn't have role master" do
      it 'respond with message' do
        expect { start! }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: 'Hello dangen master from you well be recive poll from organizers about evetns'))
      end

      it 'update role to master' do
        expect { start! }.to change(DMaster, :count)
      end

      it 'update role for right person' do
        start!
        expect(DMaster.last.person.telegram_code.to_i).to eq(from[:id])
      end
    end

    context 'when person has role master' do
      let(:d_master) { create(:d_master) }

      before { from[:id] = d_master.person.telegram_code }

      it 'respond with message' do
        expect { start! }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: 'Hello dangen master from you well be recive poll from organizers about evetns'))
      end

      it "doesn't update role to master" do
        expect { start! }.not_to change(DMaster, :count)
      end
    end
  end
end