class PostbackResponse
  def message(payload, sender_id)
    response(payload) || JobDetailsResponse.new(payload, sender_id).messages || payload
  end

  private

  def response(payload)
    I18n.t(payload, locale: :responses) if I18n.exists?(payload, :responses)
  end
end
