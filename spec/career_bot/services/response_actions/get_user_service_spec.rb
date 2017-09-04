describe ResponseAction::GetUserService do
  let(:message_hash) { {'sender' => {'id' => messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'greetings' => [{ 'value' =>  'Hello',
                                       'type' =>  'value' }] } }

  subject { described_class.new(message_data) }
  let(:user_data) { {'first_name' => name, 'id' => messenger_id} }
  let(:messenger_id) { 123 }
  let(:name) { 'Jon' }

  before do
    allow_any_instance_of(GetUserData).to receive(:user_data).and_return(user_data)
  end

  describe '#responses' do
    it 'returns proper answer' do
      expect(subject.responses).to eq I18n.t('text', locale: :wit_entities, scope: :greetings, name: name)
    end
  end
end
