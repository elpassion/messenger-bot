describe WitAction::StartGameService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'entities' => {'play_game' => [{ 'type' => 'value', 'value' => 'game'}]}
    }
  }
  let(:repository) { ConversationRepository.new }
  subject { described_class.new(request: request) }

  describe '#call' do
    it 'updates conversation context' do
      expect {
        subject.call
      }.to change {
        repository.find(conversation.id).context
      }
    end

    it 'should return play status' do
      expect(subject.call['play']).to eq true
    end

    it 'should return random winning number' do
      expect(subject.call['winningNumber'].class).to be Fixnum
    end

    it 'should return random winning in proper range' do
      number = subject.call['winningNumber']
      expect(number).to be_within(50).of 50
    end
  end
end