class PostbackResponse
  def message(payload, sender_id = nil)
    response(payload) || JobDetailsResponse.new(payload, sender_id).messages
  end

  def response(payload)
    I18n.t(payload, locale: :responses) if I18n.exists?(payload, :responses)
  end
end
