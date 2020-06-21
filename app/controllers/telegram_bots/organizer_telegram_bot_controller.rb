class TelegramBots::OrganizerTelegramBotController < TelegramBotController
  before_action :create_organizer, unless: -> { organizer }

  def start_poll!(*)
    unless person.organizer
      return respond_with :message, text: "Sorry but you don't have permission to run poll"
    end

    poll = Poll.new(organizer_id: person.id, started_at: Time.current)

    if poll.save
      send_message_to_dmasters
    else
      respond_with :message, text: 'Sorry something goes wrong, try again later'
    end
  end

  private

  def start_message
    'Hello organizer now you can run poll fot DM only on command /poll'
  end

  def send_message_to_dmasters
    DMaster.all.each do |dm|
      Telegram.bots[:masters].send_message(
        chat_id: dm.person.telegram_code,
        text: 'Poll started could you vote)\n Write /yes or /no if you can'
      )
    end
  end

  def create_organizer
    organizer = Organizer.new(person_id: person.id)

    if organizer.save
      'Organizer created'
    else
      'Something gous wrong'
    end
  end

  def organizer
    Organizer.find_by(person_id: person.id)
  end
end
