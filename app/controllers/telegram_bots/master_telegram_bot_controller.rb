class TelegramBots::MasterTelegramBotController < TelegramBotController
  before_action :create_dmaster, unless: -> { d_master }

  def yes!(*)
    respond_with :message, text: 'Your asnwer is yes Thanks!'

    organizer = Poll.last.organizer

    answer_to(organizer, 'YES')
  end

  def no!(*)
    respond_with :message, text: 'Your asnwer is no for'

    answer_to(organizer, 'NO')
  end

  private

  def start_message
    'Hello dangen master from you well be recive poll from organizers about evetns'
  end

  def create_dmaster
    d_master = DMaster.new(person_id: person.id)

    if d_master.save
      'Dungen master created'
    else
      'Sorry something goes wrong try laster'
    end
  end

  def d_master
    DMaster.find_by(person_id: person.id)
  end

  def answer_to(organizer, answer = nil)
    message = "#{d_master.person.full_name} is answred #{answer}}"

    Telegram.bots[:organizer].send_message(
      chad_id: organizer.person_id,
      text: message
    )
  end
end
