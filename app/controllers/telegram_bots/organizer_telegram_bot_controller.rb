class TelegramBots::OrganizerTelegramBotController < TelegramBotController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(data = nil, *)
    respond_with :message, text: "Hello pidr)"
  end
end
