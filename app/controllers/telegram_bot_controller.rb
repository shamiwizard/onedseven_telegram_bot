class TelegramBotController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  before_action :save_person, unless: -> { person }

  def start!(data = nil, *)
    respond_with :message, text: start_message
  end

  private

  def start_message
    "Hello #{person_params[:first_name]} #{person_params[:last_name]}"
  end

  def save_person
    person = Person.new(person_params)

    # TODO: Remove it or come up better idea
    if person.save
      'Success: Person saved'
    else
      'Error: Person is not saved!!'
    end
  end

  def person
    Person.find_by(telegram_code: person_params[:telegram_code])
  end

  def person_params
    { telegram_code: from['id'], first_name: from['first_name'], last_name: from['last_name'],
      username: from['username'], language_code: from['language_code'] }
  end
end