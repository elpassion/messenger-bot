class PostbackResponse
  def message(payload, sender_id)
    response(payload) || job_details_messages(payload, sender_id) || { text: payload }
  end

  private

  def response(payload)
   if I18n.exists?(payload, :responses)
     I18n.t(payload, locale: :responses).map do |response|
       response.is_a?(Hash) ? { attachment: response} : { text: response }
     end
   end
  end

  def job_details_messages(payload, sender_id)
    JobDetailsResponse.new(payload, sender_id).messages
  end
end
