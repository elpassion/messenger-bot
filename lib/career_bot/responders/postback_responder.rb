class PostbackResponder
  def send
    messages.each do |message|
      message.is_a?(String) ? postback.reply(text: message) : postback.reply(attachment: message)
    end
  end

  private

  attr_reader :postback, :messages

  def initialize(postback, messages)
    @postback = postback
    @messages = messages
  end
end
