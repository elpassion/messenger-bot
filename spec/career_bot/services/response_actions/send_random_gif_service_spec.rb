describe ResponseAction::SendRandomGifService do
  let(:message_hash) { {'sender' => {'id' =>  '123'},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'gif' => [{ 'value' =>  'gif',
                                  'type' =>  'value' }] } }
  let(:gif) { { url: 'www.fake-gif-url.com'} }

  subject { described_class.new(message_data) }

  before do
    allow_any_instance_of(GifService).to receive(:random_gif_url).and_return(gif)
  end

  describe '#responses' do
    it 'returns gif as a first line' do
      expect(subject.responses.first).to eq({ attachment: { type: 'image', payload: { url: gif } } })
    end

    it 'returns proper comment as a second line' do
      expect(subject.responses.last).to eq({ text: I18n.t('RANDOM_GIF', locale: :responses).first })
    end
  end
end