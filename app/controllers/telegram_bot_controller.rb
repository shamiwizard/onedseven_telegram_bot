class TelegramBotController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  before_action :person_exist, only: [:start!, :master!, :organizer!]

  def start!(data = nil, *)
    if person
      respond_with :message, text: "Hello #{person_params[:first_name]} #{person_params[:last_name]} insert you type /organizer or /master"
    else
      respond_with :message, text: "Hello #{person_params[:first_name]} #{person_params[:last_name]}"
    end
  end

  def dmaster!(data=nil, *)
    type = action_options[:command]

    update_person_type(type)
  end

  #TODO: Make one method or come with better idea
  def organizer!(data=nil, *)
    type = action_options[:command]

    update_person_type(type)
  end

  def start_poll!(data=nil, *)
    unless person.organizer?
      return respond_with :message, text: "Sorry but you don't have permission to run poll"
    end

    Person.where(person_type: 'dmaster').each do |p|
      bot.send_message(chat_id: p.telegram_code, text: "Poll started could you vote)\n Write /yes or /no if you can")
    end
  end

  def yes!
    respond_with :message, text: 'Your asnwer is yes'
  end

  def no!(data = nil, *)
    respond_with :message, text: 'Your asnwer is no'
  end

  private

  def save_person
    person = Person.new(person_params)

    # TODO: Remove it or come up better idea
    if person.save
      'Success: Person saved'
    else
      'Error: Person is not saved!!'
    end
  end

  def update_person_type(type)
    type[0] = '' if type[0] === '/'

    if person.person_type
      return respond_with :message, parse_mode: 'html', text: "Sorry but you already have role - <b>#{person.person_type}</b>"
    end

    if person.update_attributes(person_type: type.to_sym)
      respond_with :message, text: "Congratelate now your role is #{type}"
    else
      respond_with :message, text: "Sorry something goes wrong, try again later"
    end
  end

  def person_exist
    unless person
      save_person
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