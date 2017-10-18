describe GifService do
  describe '#set_gif_urls' do
    let(:gif_url) { subject.random_gif_url }

    before do
      VCR.use_cassette 'gif_urls' do
        Net::HTTP.get_response(URI('http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=animals'))
      end
    end

    it 'proper format of gif url string' do
      expect(gif_url).to be_a(String)
      expect(gif_url).to include('http')
      expect(gif_url).not_to include('[')
      expect(gif_url).not_to include(']')
    end
  end
end
