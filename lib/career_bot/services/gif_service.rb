class GifService
  def random_gif_url
    result['data']['image_url']
  end

  private

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
