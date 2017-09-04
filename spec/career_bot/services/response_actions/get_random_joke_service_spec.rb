describe ResponseAction::GetRandomJokeService do
  let(:message_hash) { {'sender' => {'id' =>  '123'},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'joke' => [{ 'value' =>  'Tell me a joke',
                                  'type' =>  'value' }] } }

  subject { described_class.new(message_data) }

  describe '#responses' do
    it 'returns joke as a first line' do
      expect(I18n.t('body', locale: :jokes).include?(subject.responses.first)).to eq true
    end

    it 'returns proper comment as a second line' do
      expect(subject.responses.last).to eq I18n.t('text', locale: :wit_entities, scope: :joke).last
    end
  end
end
