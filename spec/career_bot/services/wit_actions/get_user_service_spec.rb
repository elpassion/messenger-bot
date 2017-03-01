describe WitAction::GetUserService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => 'Hi bot',
     'entities' => {'play_game' => [{ 'type' => 'value', 'value' => 'Hi'}]}
    }
  }
  let(:repository) { ConversationRepository.new }
  let(:user_first_name) { 'Jane' }
  let(:facebook_user_data) {
    {
      'first_name' => user_first_name,
      'last_name' => 'Doe',
      'locale' => 'pl_PL',
      'timezone' => 1,
      'gender' => 'female'
    }
  }
  subject { described_class.new(request: request) }

  before do
    allow(subject).to receive(:user_data).and_return(facebook_user_data)
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
