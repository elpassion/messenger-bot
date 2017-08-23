class MessengerResponderWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  sidekiq_retry_in do |count|
    2 * (count + 1)
  end

  def perform(message)
    Message.new(message).send_message
  end
end