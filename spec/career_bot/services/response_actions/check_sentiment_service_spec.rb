describe ResponseAction::CheckSentimentService do
  let(:message_hash) { {'sender' => {'id' =>  messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:messenger_id) { '123' }
  let!(:conversation) { create(:conversation, messenger_id: messenger_id) }
  let(:entities) { { 'sentiment' => [{ 'value' => @sentiment,
                                       'type' => 'value' }] } }
  let(:message_data) { MessageData.new(message_hash) }
  let(:user_data) { {'first_name' => name, 'id' => messenger_id} }
  let(:name) { 'Jon' }

  subject { described_class.new(message_data) }

  before do
    allow_any_instance_of(GetUserData).to receive(:user_data).and_return(user_data)
  end

  describe '#responses' do
    it 'returns proper response when positive sentiment' do
      @sentiment = 'positive'
      expect(subject.responses).to eq I18n.t(@sentiment, locale: :wit_entities, scope: :sentiment, name: name)
    end

    it 'returns proper response when negative sentiment' do
      @sentiment = 'negative'
      expect(subject.responses).to eq I18n.t(@sentiment, locale: :wit_entities, scope: :sentiment)
    end
  end
end
