describe WitAction::GetSocialNetworkService do

  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => "Are you using #{social_network}?",
     'entities' => {'social_network' => [{ 'type' => 'value', 'value' => social_network }]}
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
        expect(subject.call['notFound']).to eq true
      end
    end

    context 'with available social network' do
      context 'with facebook' do
        let(:social_network) { 'facebook' }

        it 'does not update conversation context' do
          expect {
            subject.call
          }.not_to change {
            repository.find(conversation.id).context
          }
        end

        it 'should return found status' do
          expect(subject.call['found']).to eq true
        end

        it 'should return proper address for facebook' do
          expect(subject.call['address']).to eq I18n.t('facebook', locale: :social_networks)
        end
      end
    end
  end
end
