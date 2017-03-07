describe WitAction::ShowAboutUsService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:value) { 'ABOUT_US'}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => 'Tell me about elpassion',
     'entities' => {'about_us' => [{ 'type' => 'value', 'value' => value }]}
    }
  }
  let(:repository) { ConversationRepository.new }

  subject { described_class.new(request: request) }

  describe '#call' do
    context 'with not available social network' do
      let(:social_network) { 'fakebook' }
      it 'does not update conversation context' do
        expect {
          subject.call
        }.not_to change {
          repository.find(conversation.id).context
        }
      end

      it 'should return not found status' do
        expect(subject.call['about_us']).to eq value
      end
    end
  end
end
