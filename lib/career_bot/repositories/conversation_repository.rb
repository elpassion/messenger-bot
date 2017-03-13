class ConversationRepository < Hanami::Repository
  def find_by_session_uid(session_uid)
    conversations.where(session_uid: session_uid).first
  end

  def find_by_messenger_id(messenger_id)
    conversations.where(messenger_id: messenger_id).first
  end

  def find_or_create_by_messenger_id(messenger_id)
    find_by_messenger_id(messenger_id) || create(messenger_id: messenger_id)
  end

  def records_updated_before(time)
    conversations.where('updated_at < ?', time)
  end
end
