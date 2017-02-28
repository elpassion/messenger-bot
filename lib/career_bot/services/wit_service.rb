class WitService
  def initialize(message)
    @message = message
  end

  def send
    set_session_uid if context.empty?
    client.run_actions(session_uid, message.text, context)
  end

  private

  attr_reader :message

  def set_session_uid
    repository.update(conversation.id, session_uid: SecureRandom.uuid)
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
