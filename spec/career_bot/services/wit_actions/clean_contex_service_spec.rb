describe WitAction::CleanContextService do

  let(:session_uid) { 'session_id' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
      'context' => {'play'=>true, 'winningNumber'=>68, 'won'=>true, 'number'=>68},
      'entities' => nil
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
      }.to({})
    end

    it 'should return empty hash' do
      expect(subject.call).to eq({})
    end
  end
end
