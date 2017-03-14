class MessageResponder
  def initialize(message)
    @message = message
  end

  def send
    quick_reply ? run_postback : send_to_wit
  end

  private
  attr_reader :message

  def run_postback
    PostbackResponder.new(message, PostbackResponse.new.message(message.quick_reply)).send
  end

  def send_to_wit
    WitService.new(message).send
  end

  def quick_reply
    message.quick_reply
  end
end
