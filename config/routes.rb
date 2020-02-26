Rails.application.routes.draw do
  telegram_webhook TelegramBotController, :masters
end
