class SendNotificationsWorker
  include Sidekiq::Worker

  def perform(message)
    conversations.each do |conversation|
      FacebookMessenger.new.deliver(conversation.messenger_id, { text: message })
    end
  end

  private

  def conversations
    @conversations ||= ConversationRepository.new.with_notifications_allowed
  end
end
