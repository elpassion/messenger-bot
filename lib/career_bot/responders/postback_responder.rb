class PostbackResponder
  def send
    send_postback_messages
  end

  def send_postback_messages
    messages.each { |message| postback.reply(message) }
  end

  private

  attr_reader :postback, :messages

  def initialize(postback, messages)
    @postback = postback
    @messages = Array(messages)
  end
end
