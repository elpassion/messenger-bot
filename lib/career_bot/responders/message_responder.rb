class MessageResponder
  def initialize(message)
    @message = message
  end

  def send
    quick_reply && quick_reply != 'empty' ? run_postback : send_to_wit
  end

  private

  attr_reader :message

  def run_postback
    PostbackResponder.new(message, postback_message).send
  end

  def send_to_wit
    WitService.new(message).send
  end

  def quick_reply
    @quick_reply ||= message.quick_reply
  end

  def postback_message
    PostbackResponse.new.message(quick_reply)
  end
end
