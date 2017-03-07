describe WitAction::GetUserService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => 'Hi bot',
     'entities' => {'greetings' => [{ 'type' => 'value', 'value' => 'Hi'}]}
    }
  }
  let(:repository) { ConversationRepository.new }
  let(:user_first_name) { 'Jane' }

  subject { described_class.new(request: request) }

  before do
    allow_any_instance_of(MessengerUserRepository).to receive(:name).and_return(user_first_name)
  end

  describe '#call' do
    it 'does not update conversation context' do
      expect {
        subject.call
      }.not_to change {
        repository.find(conversation.id).context
      }
    end

    it 'should return users name' do
      expect(subject.call['name']).to eq user_first_name
    end
  end
end
