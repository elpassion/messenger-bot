class CleanConversationContextWorker
  include Sidekiq::Worker

  def perform
    conversations = ConversationRepository.new.records_updated_before(Time.now - 15 * 60)

    conversations.each do |conversation|
      ConversationRepository.new.update(conversation.id, context: {})
    end
  end
end
