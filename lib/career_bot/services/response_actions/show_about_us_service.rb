class ResponseAction::ShowAboutUsService < ResponseAction
  def call
    bot_deliver(attachment: I18n.t('ABOUT_US', locale: :responses).first)
  end
end
