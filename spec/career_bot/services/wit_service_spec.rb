describe WitService do

  let(:message) { double(:message, text: 'Play game', sender: { 'id' => messenger_id }) }
  let(:repository) { ConversationRepository.new }
  subject { described_class.new(message.sender['id'], message.text) }

  before do
    allow_any_instance_of(Wit).to receive(:run_actions).and_return(true)
  end

  describe '#send' do
    context 'with new messenger user' do
      let(:messenger_id) { 'new_user' }
      it 'should create new conversation' do
        expect {
          subject.send
        }.to change {
          repository.all.count
        }.by(1)
      end
    end

    context 'with existing conversation' do
      let(:messenger_id) { 'existing_user' }
      let!(:conversation) { create(:conversation, messenger_id: messenger_id, context: context )}

      context 'with empty context' do
        let(:context) { {} }
        it 'should change session_uid' do
          expect {
            subject.send
          }.to change {
            repository.find_by_messenger_id(messenger_id).session_uid
          }
        end
      end

      context 'with empty context' do
        let(:context) { { 'test': 123 } }
        it 'should change session_uid' do
          expect {
            subject.send
          }.not_to change {
            repository.find_by_messenger_id(messenger_id).session_uid
          }
        end
      end
    end
  end
end
