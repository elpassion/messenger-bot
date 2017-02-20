class MediaResponse
  def projects_details_messages
    [{ type: 'image', payload: { url: I18n.t('urls.projects_gif') } },
     I18n.t('text_messages.what_we_do_message'), I18n.t('text_messages.see_more_message')]
  end

  def company_details_messages
    [{ type: 'image', payload: { url: I18n.t('urls.company_gif') } },
     I18n.t('text_messages.social_media_links')]
  end
end
