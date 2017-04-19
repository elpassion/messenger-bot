class HandleWitResponseWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  sidekiq_retry_in do |count|
    2 * (count + 1)
  end

  def perform(sender_id, text)
    WitService.new(sender_id, text).send
  end
end
