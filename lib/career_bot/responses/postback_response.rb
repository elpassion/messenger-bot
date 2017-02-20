class PostbackResponse
  def message(payload)
    case payload
      when 'WELCOME_PAYLOAD'
        ButtonsResponse.new.welcome_message
      when 'JOB_OFFERS'
        I18n.t('text_messages.job_offers_message')
      when 'ABOUT_US'
        ButtonsResponse.new.about_us_message
      when 'PLAY_A_GAME'
        ''
      when 'WHAT_WE_DO'
        MediaResponse.new.projects_details_messages
      when 'COMPANY'
        MediaResponse.new.company_details_messages
      when 'PEOPLE'
        I18n.t('text_messages.team_members_message')
      else
        JobDetailsResponse.new(payload).messages
    end
  end

  def second_version_message(payload)
    messages[payload.to_sym] || JobDetailsResponse.new(payload).messages
  end

  private

  def messages
    {
      WELCOME_PAYLOAD: ButtonsResponse.new.welcome_message,
      JOB_OFFERS: I18n.t('text_messages.job_offers_message'),
      ABOUT_US: ButtonsResponse.new.about_us_message,
      WHAT_WE_DO: MediaResponse.new.projects_details_messages,
      COMPANY: MediaResponse.new.company_details_messages,
      PEOPLE: I18n.t('text_messages.team_members_message')
    }
  end
end
