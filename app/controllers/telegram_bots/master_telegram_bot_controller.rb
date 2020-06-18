class TelegramBots::MasterTelegramBotController < TelegramBotController
  before_action :create_dmaster, unless: -> { d_master }

  def yes!(date = nil, *)
    respond_with :message, text: 'Your asnwer is yes'
  end

  def no!(data = nil, *)
    respond_with :message, text: 'Your asnwer is no'
  end

  private

  def start_message
    "Hello dangen master from you well be recive poll from organizers about evetns"
  end

  def create_dmaster
    d_master = DMaster.new(person_id: person.id)

    if d_master.save
      "Dungen master created"
    else
      "Sorry something goes wrong try laster"
    end
  end

  def d_master
    DMaster.find_by(person_id: person.id)
  end
end
