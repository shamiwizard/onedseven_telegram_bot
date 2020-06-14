Rails.application.routes.draw do
  telegram_webhook TelegramBots::MasterTelegramBotController, :masters
  telegram_webhook TelegramBots::OrganizerTelegramBotController, :organizers
end
