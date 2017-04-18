class HandleWitResponseWorker
  include Sidekiq::Worker

  def perform(sender_id, text)
    WitService.new(sender_id, text).send
  end
end
