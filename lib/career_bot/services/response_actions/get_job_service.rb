class ResponseAction::GetJobService < ResponseAction
  def responses
    JobOffersResponder.new(conversation: message_data.conversation,
                           job_keyword: position).response
  end

  private

  def position
    @position ||= entities[entities.keys.first].first['value']
  end
end
