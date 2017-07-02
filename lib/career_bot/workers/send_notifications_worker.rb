class SendNotificationsWorker
  include Sidekiq::Worker

  def perform
    conversations.each do |conversation|
      WitService.new(conversation.messenger_id, 'broadcast').send
    end
  end

  private

  def conversations
    ConversationRepository.new.with_notifications_allowed
  end
end
