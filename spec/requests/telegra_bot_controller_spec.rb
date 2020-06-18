require 'rails_helper'
require 'telegram/bot/rspec/integration/poller'

RSpec.describe TelegramBotController, telegram_bot: :poller do
  let(:bot) { Telegram::Bot::ClientStub.new('token') }

  after { Telegram.bots.each_value(&:reset) }

  describe "#start!" do
    let(:from) { attributes_for(:person_params)  }

    subject { dispatch_command(:start) }

    context "when person is new" do
      it "return message" do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]}"))
      end

      it "save new person" do
        expect { subject }.to change { Person.count }
      end
    end

    context "when person is exist" do
      let(:person) { create(:person) }

      before { from[:id] = person.telegram_code }

      it "return message" do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]}"))
      end

      it "doesn't save exist person" do
        expect { subject }.to_not change { Person.count }
      end
    end

    context "when person hasn't telegram_code" do
      before { from[:id]= '' }

      it "doesn't save person" do
        expect { subject }.to_not change {Person.count}
      end
    end
  end
end