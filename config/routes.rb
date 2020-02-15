Rails.application.routes.draw do

  telegram_webhook TelegramBot, :masters

end
