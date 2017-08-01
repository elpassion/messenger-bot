class HandleWitResponseWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  sidekiq_retry_in do |count|
    2 * (count + 1)
  end

  def perform(recipient_id, text)
    WitService.new(recipient_id, text).send
  end
end
