class SetRandomGifUrlsWorker
  include Sidekiq::Worker

  def perform
    GifService.new.set_gif_urls
  end
end
