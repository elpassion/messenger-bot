class WitService
  def initialize(sender_id, text)
    @sender_id = sender_id
    @text = text
  end

  def send
    clean_context
    set_session_uid
    run_client_actions
  end

  private

  attr_reader :sender_id, :text

  def run_client_actions
    client.run_actions(session_uid, text, context)
    rescue WitException
    client.run_actions(session_uid, 'error', context)
  end

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
    context.any? && conversation.updated_at < Time.now.utc - 15 * 60
  end

  def session_uid
    conversation.session_uid
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
