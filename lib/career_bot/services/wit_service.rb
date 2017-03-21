class WitService
  def initialize(message)
    @message = message
  end

  def send
    clean_context
    set_session_uid
    client.run_actions(session_uid, message.text, context)
  end

  private

  attr_reader :message

  def set_session_uid
    if context.empty?
      repository.update(conversation.id, session_uid: SecureRandom.uuid)
    end
  end

  def clean_context
    if clean_conversation_context?
      repository.update(conversation.id, context: {})
    end
  end

  def clean_conversation_context?
    context.any? && conversation.updated_at < Time.now - 15 * 60
  end

  def session_uid
    conversation.session_uid
  end

  def sender_id
    message.sender['id']
  end

  def repository
    @repository ||= ConversationRepository.new
  end

  def conversation
    repository.find_or_create_by_messenger_id(sender_id)
  end

  def context
    conversation.context.to_h
  end

  def client
    WitConnection.instance.client
  end
end
