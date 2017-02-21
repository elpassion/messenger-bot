class MockPostback
  attr_reader :sent_messages, :payload

  def initialize(payload)
    @sent_messages = []
    @payload = payload
  end

  def reply(message)
    sent_messages << message
  end

  def payload
    @payload
  end
end