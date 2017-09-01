describe ResponseAction::ShowAboutUsService do
  let(:message_hash) { {'sender' => {'id' =>  '123'},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'about_us' => [{ 'value' =>  'About us',
                                      'type' =>  'value' }] } }
  let(:gif) { { url: 'www.fake-gif-url.com'} }

  subject { described_class.new(message_data) }

  describe '#responses' do
    it 'returns gif as a first line' do
      expect(subject.responses.first).to eq({ attachment: I18n.t('ABOUT_US', locale: :responses).first})
    end
  end
end
