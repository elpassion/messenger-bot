class ResponseAction::ShowMainMenuService < ResponseAction
  def responses
    [ { attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first } ]
  end
end
