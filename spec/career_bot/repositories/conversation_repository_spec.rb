RSpec.describe ConversationRepository do
  let(:repository) { described_class.new }

  describe '#find_by_session_uid' do
    let(:session_uid_1) { 'test_1' }
    let(:session_uid_2) { 'test_2' }
    let!(:conversation_1) { create(:conversation, session_uid: session_uid_1) }
    let!(:conversation_2) { create(:conversation, session_uid: session_uid_2) }

    it 'should return proper conversation instance' do
      expect(repository.find_by_session_uid(session_uid_1).id).to eq conversation_1.id
      expect(repository.find_by_session_uid(session_uid_2).id).to eq conversation_2.id
    end

    it 'should return nil with no existing session_uid' do
      expect(repository.find_by_session_uid('fake')).to eq nil
    end
  end

  describe '#find_by_messegner_id' do
    let(:messenger_id_1) { 'test_1' }
    let(:messenger_id_2) { 'test_2' }
    let!(:conversation_1) { create(:conversation, messenger_id: messenger_id_1) }
    let!(:conversation_2) { create(:conversation, messenger_id: messenger_id_2) }

    it 'should return proper conversation instance' do
      expect(repository.find_by_messenger_id(messenger_id_1).id).to eq conversation_1.id
      expect(repository.find_by_messenger_id(messenger_id_2).id).to eq conversation_2.id
    end

    it 'should return nil with no existing session_uid' do
      expect(repository.find_by_session_uid('fake')).to eq nil
    end
  end

  describe 'find_or_create_by_messenger_id' do
    context 'when requesting for existing conversation' do
      let(:messenger_id_1) { 'messenger_id_1' }
      let(:messenger_id_2) { 'messenger_id_2' }
      let!(:conversation_1) { create(:conversation, messenger_id: messenger_id_1) }
      let!(:conversation_2) { create(:conversation, messenger_id: messenger_id_2) }

      it 'should find proper conversation' do
        expect(repository.find_or_create_by_messenger_id(messenger_id_1).id).to eq conversation_1.id
        expect(repository.find_or_create_by_messenger_id(messenger_id_2).id).to eq conversation_2.id
      end

      it 'should not create new conversation' do
        expect {
          repository.find_or_create_by_messenger_id(messenger_id_1)
        }.not_to change {
          repository.all.count
        }
      end
    end

    context 'when requesting for new not existing conversation' do
      let(:messenger_id) { 'new_user' }
      it 'should create new conversation' do
        expect {
          repository.find_or_create_by_messenger_id(messenger_id)
        }.to change {
          repository.all.count
        }
      end
    end
  end
end
