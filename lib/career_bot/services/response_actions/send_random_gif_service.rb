class ResponseAction::SendRandomGifService < ResponseAction
  def responses
    [{ attachment: { type: 'image', payload: { url: gif_url } } },
     { text: I18n.t('RANDOM_GIF', locale: :responses)[0] }]
  end

  private

  def gif_url
    GifService.new.random_gif_url
  end
end
