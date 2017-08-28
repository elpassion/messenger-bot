class ResponseAction::GetDetailsService < ResponseAction
  def responses
    JobDetailsResponder.new(conversation: message_data.conversation,
                            details: details).responses
  end

  private

  def details
    @details ||= entities[entities.keys.first].first['value']
  end
end
