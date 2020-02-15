class TelegramBotController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  def start!(data = nil)

  end
end