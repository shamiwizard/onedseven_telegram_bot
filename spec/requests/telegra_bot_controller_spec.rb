require 'rails_helper'
require 'telegram/bot/rspec/integration/rails'

RSpec.describe TelegramBotController, telegram_bot: :rails do
  after { Telegram.bots.each_value(&:reset) }
  let(:bot) { Telegram.bots[:masters] }
  let!(:person) { create(:person) }

  describe '#start!' do
    let!(:from) { attributes_for(:person_params)  }

    subject { dispatch_command(:start) }

    context "when user doesn't exist" do
      before { from[:id] = '' }

      it 'return message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]}"))
      end

      it "doesn't create new person" do
        expect{ subject }.not_to change { Person.count }
      end
    end

    context "when user is exist" do
      it 'return message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
          .with(hash_including(text: "Hello #{from[:first_name]} #{from[:last_name]} insert you type /organizer or /master"))
      end
      it 'create new person' do
        expect{ subject }.to change { Person.count }
      end
    end
  end

  describe '#dmaster!' do
    before { from[:id] = person.telegram_code }

    subject { dispatch_command(:dmaster) }

    context 'when person already has role' do
      context 'when person role is master' do
        it 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Sorry but you already have role - <b>#{person.person_type}</b>"))
        end
      end

      context 'when person role is orginiaer' do
        before { person.update_attributes(person_type: :organizer) }

        it 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Sorry but you already have role - <b>#{person.person_type}</b>"))
        end
      end
    end

    context 'when peson hasn\'t role' do
      before do
        person.update_attributes(person_type: '')
      end

      it 'retrun message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Congratelate now your role is dmaster"))
      end
    end
  end

  describe '#organizer!' do
    before do
      from[:id] = person.telegram_code
      person.update_attributes(person_type: :organizer)
    end

    subject { dispatch_command(:organizer) }

    context 'when person already has role' do
      context 'when person role is organizer' do
        it 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Sorry but you already have role - <b>#{person.person_type}</b>"))
        end
      end

      context 'when person role is master' do
        before { person.update_attributes(person_type: :dmaster) }

        it 'return message' do
          expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Sorry but you already have role - <b>#{person.person_type}</b>"))
        end
      end
    end

    context 'when peson hasn\'t role' do
      before { person.update_attributes(person_type: '') }

      it 'retrun message' do
        expect { subject }.to make_telegram_request(bot, :sendMessage)
            .with(hash_including(text: "Congratelate now your role is organizer"))
      end
    end
  end
end