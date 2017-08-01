class ApplyResponderWorker
  include Sidekiq::Worker

  def perform(conversation_id, message, params)
    ApplyResponder.new(conversation_id, message, params).response
  end
end
