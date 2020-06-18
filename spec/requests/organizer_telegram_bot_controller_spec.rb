require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBots::OrganizerTelegramBotController, telegram_bot: :rails do
  let(:bot) { Telegram.bots[:organizers] }

  after { Telegram.bots.each_value(&:reset) }

  describe "#start!" do
    let(:from) { attributes_for(:person_params) }

    subject { dispatch_command(:start) }

    context "when person doesn't have role organizer" do
      it "return message" do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello organizer now you can run poll fot DM only on command /poll"))
      end

      it "update role to organizer" do
        expect { subject }.to change { Organizer.count }
      end

      it "update role for right person" do
        subject
        expect(Organizer.last.person.telegram_code.to_i).to eq(from[:id])
      end
    end

    context "when person have role organizer" do
      let(:organizer) { create(:organizer) }

      before { from[:id] = organizer.person.telegram_code }

      it "return message" do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello organizer now you can run poll fot DM only on command /poll"))
      end

      it "update person role to organizer" do
        expect { subject }.to_not change { Organizer.count }
      end
    end
  end
end