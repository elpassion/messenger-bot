class BotResponder
  def initialize(**options)
    @bot_interface = options[:bot_interface] || FacebookMessenger.new
    @job_repository = options[:job_repository] || JobRepository.new
  end

  def bot_deliver(message)
    bot_interface.deliver(messenger_id, message) if messenger_id
  end

  private

  attr_reader :bot_interface, :job_repository

  def messenger_id
    conversation.messenger_id if conversation
  end

  def conversation
    @conversation ||= repository.find_by_session_uid(session_uid)
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
