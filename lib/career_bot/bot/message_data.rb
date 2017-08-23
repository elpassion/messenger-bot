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

  def text
    @text ||= message['message']['text']
  end

  def attachment_url
    return unless message['message']['attachments']
    @attachment_url ||= message['message']['attachments'].first['payload']['url']
  end

  def conversation_id
    @conversation_id = conversation.id
  end

  def quick_reply
    return unless message['message']['quick_reply']
    @quick_reply ||= message['message']['quick_reply']['payload']
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

  private

  def conversation
    @conversation = repository.find_by_messenger_id(sender_id)
  end
end
