class ConversationRepository < Hanami::Repository
  
  def find_by_session_uid(session_uid)
    conversations
      .where(session_uid: session_uid)
      .order(:created_at)
      .first
  end

  def find_by_messenger_id(messenger_id)
    conversations
      .where(messenger_id: messenger_id)
      .order(:created_at)
      .first
  end
end
