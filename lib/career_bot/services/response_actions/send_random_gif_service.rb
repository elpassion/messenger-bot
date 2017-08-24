class ResponseAction::SendRandomGifService < ResponseAction
  def call
    bot_deliver(attachment: { type: 'image', payload: { url: gif_url } } )
    bot_deliver(text: I18n.t('RANDOM_GIF', locale: :responses) )
  end

  private

  def gif_url
    GifService.new.random_gif_url
  end
end
