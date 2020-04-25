require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBotController, telegram_bot: :rails do
  after { Telegram.bots.each_value(&:reset) }
  describe '#start!' do
    let(:bot) { Telegram.bots[:masters] }
    let!(:from) { attributes_for(:person_params)  }

    context "when user doesn't exist" do
      before { from[:id] = '' }

      it 'return message' do
        expect { dispatch_command(:start) }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]}"))
      end
    end

    context "when user is exist" do
      it 'return message' do
        expect { dispatch_command(:start) }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]} insert you type /organizator or /master"))
      end
    end
  end
end