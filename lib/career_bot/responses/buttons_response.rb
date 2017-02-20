class ButtonsResponse
  def welcome_message
    [ ButtonTemplate.new(I18n.t('text_messages.welcome_message')).to_hash(welcome_buttons) ]
  end

  def about_us_message
    [ ButtonTemplate.new(I18n.t('text_messages.about_us_text')).to_hash(about_us_buttons) ]
  end

  private

  def welcome_buttons
    [ PostbackButton.new(I18n.t('buttons.find_a_job'), 'JOB_OFFERS').to_hash,
      PostbackButton.new(I18n.t('buttons.play_a_game'), 'PLAY_A_GAME').to_hash,
      PostbackButton.new(I18n.t('buttons.about_us'), 'ABOUT_US').to_hash ]
  end

  def about_us_buttons
    [ PostbackButton.new(I18n.t('buttons.company'), 'COMPANY').to_hash,
      PostbackButton.new(I18n.t('buttons.people'), 'PEOPLE').to_hash,
      PostbackButton.new(I18n.t('buttons.what_we_do'), 'WHAT_WE_DO').to_hash ]
  end
end
