class ResponseAction::ShowMainMenuService < ResponseAction
  def call
    bot_deliver(attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first)
  end
end
