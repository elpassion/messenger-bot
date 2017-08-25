class ResponseAction::GetDetailsService < ResponseAction
  def call
    responses.each do |response|
      bot_deliver(response)
    end
  end

  private

  def responses
    JobDetailsResponder.new(conversation: message_data.conversation,
                            details: details).responses
  end

  def details
    @details ||= entities[entities.keys.first].first['value']
  end
end
