class HandleWitResponseWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(sender_id, text)
    WitService.new(sender_id, text).send
  end
end
