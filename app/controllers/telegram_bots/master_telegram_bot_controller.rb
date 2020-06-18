class TelegramBots::MasterTelegramBotController < TelegramBotController
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
end
