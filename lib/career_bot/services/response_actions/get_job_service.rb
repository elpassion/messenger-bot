class ResponseAction::GetJobService < ResponseAction
  def call
    responses.each do |response|
      bot_deliver(response)
    end
  end

  private

  def responses
    JobOffersResponder.new(conversation: message_data.conversation,
                           job_keyword: position).response
  end

  def position
    @position ||= entities[entities.keys.first].first['value']
  end
end
