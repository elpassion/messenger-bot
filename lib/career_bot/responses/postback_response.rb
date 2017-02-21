class PostbackResponse
  def message(payload)
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
