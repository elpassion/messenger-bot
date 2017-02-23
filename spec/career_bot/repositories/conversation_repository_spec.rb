RSpec.describe ConversationRepository do
  let(:repository) { described_class.new }

  describe '#find_by_session_uid' do
    let(:session_uid_1) { 'test_1' }
    let(:session_uid_2) { 'test_2' }
    let(:session_uid_3) { 'test_3' }
    let!(:conversation_1) { create(:conversation, session_uid: session_uid_1) }
    let!(:conversation_2) { create(:conversation, session_uid: session_uid_2) }
    let!(:conversation_3) { create(:conversation, session_uid: session_uid_3) }

    it 'should return proper conversation instance' do
      expect(repository.find_by_session_uid(session_uid_1).id).to eq conversation_1.id
      expect(repository.find_by_session_uid(session_uid_2).id).to eq conversation_2.id
      expect(repository.find_by_session_uid(session_uid_3).id).to eq conversation_3.id
    end

    it 'should return nil with no existing session_uid' do
      expect(repository.find_by_session_uid('fake')).to eq nil
    end
  end
end
