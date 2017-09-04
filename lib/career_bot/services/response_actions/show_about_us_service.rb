class ResponseAction::ShowAboutUsService < ResponseAction
  def responses
    [{ attachment: I18n.t('ABOUT_US', locale: :responses).first }]
  end
end
