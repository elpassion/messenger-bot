class PostbackResponder
  def send
    payload_included_in_wit_actions? ? send_to_wit(payload) : send_postback_messages
  end

  private

  attr_reader :postback, :messages

  def initialize(postback, messages)
    @postback = postback
    @messages = Array(messages)
  end

  def payload_included_in_wit_actions?
    %w(internship).include?(payload)
  end

  def send_to_wit(payload)
    WitService.new(messenger_id, payload).send
  end

  def send_postback_messages
    messages.each do |message|
      message.is_a?(String) ? postback.reply(text: message) : postback.reply(attachment: message)
    end
  end

  def payload
    @payload ||= postback.payload ? postback.payload : postback.quick_reply
  end

  def messenger_id
    postback.sender['id']
  end
end
