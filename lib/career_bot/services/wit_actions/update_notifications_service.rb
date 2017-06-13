class WitAction::UpdateNotificationsService < WitAction
  def call
    update_conversation_notifications_flag
    context
  end

  private

  def update_conversation_notifications_flag
    repository.update(conversation_id, notifications: true) if conversation_id
  end

  def session_id
    request['session_id']
  end

  def conversation_id
    repository.find_by_session_uid(request['session_id']).id
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
