describe WitAction::CheckSentimentService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => 'I like you',
     'entities' => {'sentiment' => [{ 'type' => 'value', 'value' => sentiment }]}
    }
  }
  let(:repository) { ConversationRepository.new }
  let(:user_first_name) { 'Jane' }

  subject { described_class.new(request: request) }

  before do
    allow_any_instance_of(MessengerUserRepository).to receive(:name).and_return(user_first_name)
  end

  describe '#call' do
    context 'with positive sentiment' do
      let(:sentiment) { 'positive' }

      it 'should return positive status' do
        expect(subject.call['positive']).to eq true
      end

      it 'should return user name' do
        expect(subject.call['name']).to eq user_first_name
      end

    end

    context 'with negative sentiment' do
      let(:sentiment) { 'negative' }

      it 'should return negative status' do
        expect(subject.call['negative']).to eq true
      end
    end
  end
end
