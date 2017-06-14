class PostbackResponse
  def message(payload)
    response(payload) || JobDetailsResponse.new(payload).messages || payload
  end

  def response(payload)
    I18n.t(payload, locale: :responses) if I18n.exists?(payload, :responses)
  end
end
