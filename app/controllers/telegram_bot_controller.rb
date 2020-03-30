class TelegramBotController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  before_action :person_exist, only: [:start!]

  def start!(data = nil, *)
    if person_exist?
      respond_with :message, text: "Hello #{person_params[:first_name]} #{person_params[:last_name]} insert you type /organizator or /master"
    else
      respond_with :message, text: "Hello #{person_params[:first_name]} #{person_params[:last_name]}"
    end
  end



  private

  def save_person
    person = Person.new(person_params)

    # TODO: Remove it or come up with normal message
    if person
      'Success: Person saved'
    else
      'Error: Person is not saved!!'
    end
  end

  def person_exist
    unless Person.find_by(telegram_code: person_params[:telegram_code])
      save_person
    end
  end

  def person_exist?
    Person.find_by(telegram_code: person_params[:telegram_code])
  end

  def person_params
    { telegram_code: from['id'], first_name: from['first_name'], last_name: from['last_name'],
      username: from['username'], language_code: from['language_code'] }
  end
end