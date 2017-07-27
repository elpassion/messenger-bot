class MessageResponder
  def initialize(message)
    @message = message
  end

  def set_action
    if conversation.apply
      run_apply_process
    else
      quick_reply && quick_reply != 'empty' ? run_postback : send_to_wit
    end
  end

  private

  attr_reader :message

  def run_apply_process
    ApplyResponderWorker.perform_async(conversation.id, message_text, params)
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

  def params
    { attachment_url: attachment_url, quick_reply: message.quick_reply }
  end

  def attachment_url
    message.attachments.first['payload']['url'] if message.attachments
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
