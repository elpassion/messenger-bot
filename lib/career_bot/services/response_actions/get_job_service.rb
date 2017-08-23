class ResponseAction::GetJobService < ResponseAction
  def call
    JobOffersResponder.new(session_uid: message_data.session_uid,
                           job_keyword: position).response
  end

  private

  def position
    @position ||= entities[entities.keys.first].first['value']
  end
end
