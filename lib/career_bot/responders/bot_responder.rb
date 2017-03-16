class BotResponder
  def initialize(**options)
    @bot_interface = options[:bot_interface] || FacebookMessenger.new
    @job_repository = options[:job_repository] || JobRepository.new
  end

  private

  attr_reader :bot_interface, :job_repository

  def bot_deliver(message)
    bot_interface.deliver(messenger_id, message)
  end

  def messenger_id
    repository.find_by_session_uid(session_uid).messenger_id
  end

  def repository
    @repository ||= ConversationRepository.new
  end

  def conversation
    repository.find_by_session_uid(session_uid)
  end
end
