class MockMessenger
  attr_reader :sent_messages

  def initialize
    @sent_messages = []
  end

  def deliver(session_id, message)
    sent_messages << message
    "mid.#{session_id}:123"
  end
end
