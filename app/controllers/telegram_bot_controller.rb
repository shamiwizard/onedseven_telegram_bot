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
    if person.d_master
      return respond_with :message, text: "You can't update your role because your role is already Dungeon master"
    end

    d_master = DMaster.new(person_id: person.id)

    if d_master.save
      respond_with :message, text: "Congratelate now your role is Dungeon master"
    else
      respond_with :message, text: "Sorry something goes wrong, try again later"
    end
  end

  def organizer!(data=nil, *)
    if person.organizer
      return respond_with :message, text: "You can't update your role because your role is already Organizer"
    end

    organizer = Organizer.new(person_id: person.id)

    if organizer.save
      respond_with :message, text: "Congratelate now your role is Organizer"
    else
      respond_with :message, text: "Sorry something goes wrong, try again later"
    end
  end

  def start_poll!(data=nil, *)
    unless person.organizer?
      return respond_with :message, text: "Sorry but you don't have permission to run poll"
    end

    if Poll.create(organizer_id: person.id, started_at: Time.now)
      send_message_to_dmasters
    else
      respond_with :message, text: "Sorry something goes wrong, try again later"
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

  def send_message_to_dmasters
    DMaster.all.each do |p|
      bot.send_message(chat_id: p.telegram_code, text: "Poll started could you vote)\n Write /yes or /no if you can")
    end
  end
end