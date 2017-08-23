class ResponseAction::GetDetailsService < ResponseAction
  def call
    JobDetailsResponder.new(session_uid: message_data.session_uid,
                            details: details).set_response
  end

  private

  def details
    @details ||= entities[entities.keys.first].first['value']
  end
end
