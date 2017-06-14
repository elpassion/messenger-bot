class MessageResponder
  def initialize(message)
    @message = message
  end

  def set_action
    if conversation.apply
      apply
    else
      quick_reply && quick_reply != 'empty' ? run_postback : send_to_wit
    end
  end

  private

  attr_reader :message

  def apply
    ApplyResponder.new(conversation_id: conversation.id).response
  end

  def run_postback
    PostbackResponder.new(message, postback_message).send
  end

  def send_to_wit
    HandleWitResponseWorker.perform_async(message_sender_id, message_text)
  end

  def postback_message
    PostbackResponse.new.message(quick_reply, message_sender_id)
  end

  def quick_reply
    @quick_reply ||= message.quick_reply
  end

  def conversation
    repository.find_or_create_by_messenger_id(message_sender_id)
  end

  def message_sender_id
    message.sender['id']
  end

  def message_text
    message.text
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
