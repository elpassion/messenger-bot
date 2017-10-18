class GifService
  def random_gif_url
    gif_urls.sample
  end

  def set_gif_urls
    Sidekiq.redis do |connection|
      connection.set('gif_urls', gif_urls_array)
    end
  end

  private

  def gif_urls
    gif_urls = Sidekiq.redis { |connection| connection.get 'gif_urls' }
    gif_urls.split(', ').map { |url| url.delete('[\\"') }
  end

  def gif_urls_array
    array = Array.new
    50.times { array.push(result['data']['image_url']) }
    array
  end

  def result
    JSON.parse(response.body)
  end

  def response
    Net::HTTP.get_response(parsed_url)
  end

  def parsed_url
    URI.parse(ENV['GIPHY_URL'])
  end
end
