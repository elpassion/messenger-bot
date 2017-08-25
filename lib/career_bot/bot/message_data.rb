class MessageData
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def sender_id
    @sender_id ||= message['sender']['id']
  end

  def apply
    @apply ||= conversation.apply
  end

  def conversation_id
    @conversation_id = conversation.id
  end

  def entities
    @entities ||= message['message']['nlp']['entities']
  end

  def repository
    @repository = ConversationRepository.new
  end

  # probably to remove after JobOffersResponder refactor
  def session_uid
    conversation.session_uid
  end

  def conversation
    @conversation = repository.find_by_messenger_id(sender_id)
  end
end
