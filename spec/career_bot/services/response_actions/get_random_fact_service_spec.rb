describe ResponseAction::GetRandomNumberFactService do
  let(:message_hash) { {'sender' => {'id' =>  '123'},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'random_fact' => [{ 'value' =>  'Random fact',
                                        'type' =>  'value' }] } }

  let(:fact) { '62 is the number which Sigmund Freud has an irrational fear of.' }
  let(:numbers_api_response) { double('NumbersApi', body: fact ) }

  subject { described_class.new(message_data) }

  before do
    allow(Faraday).to receive(:get).with('http://numbersapi.com/random/trivia').and_return(numbers_api_response)
  end

  describe '#responses' do
    it 'returns proper comment as a first line' do
      expect(subject.responses.first).to eq I18n.t('text', locale: :wit_entities, scope: :random_fact).first
    end

    it 'returns fact as a second line' do
      expect(subject.responses.last).to eq fact
    end
  end
end
