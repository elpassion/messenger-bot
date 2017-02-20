class ConversationRepository < Hanami::Repository
  
  def find_by_session_id(session_id)
    conversations
      .where(session_id: session_id)
      .order(:created_at)
      .first
  end
end
