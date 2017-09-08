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

  def conversation
    @conversation = repository.find_or_create_by_messenger_id(sender_id)
  end
end
