class MessageResponder
  def initialize(message)
    @message = message
  end

  def set_action
    quick_reply && quick_reply != 'empty' ? run_postback : send_to_wit
  end

  private

  attr_reader :message

  def run_postback
    PostbackResponder.new(message, postback_message).send
  end

  def send_to_wit
    HandleWitResponseWorker.perform_async(message_sender_id, message_text)
  end

  def postback_message
    PostbackResponse.new.message(quick_reply)
  end

  def quick_reply
    @quick_reply ||= message.quick_reply
  end

  def message_sender_id
    message.sender['id']
  end

  def message_text
    message.text
  end
end
