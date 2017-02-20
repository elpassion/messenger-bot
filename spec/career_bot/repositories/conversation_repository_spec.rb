RSpec.describe ConversationRepository do
  let(:repository) { described_class.new }

  describe '#find_by_session_id' do
    let(:session_id_1) { 'test_1' }
    let(:session_id_2) { 'test_2' }
    let(:session_id_3) { 'test_3' }
    let!(:conversation_1) { create(:conversation, session_id: session_id_1) }
    let!(:conversation_2) { create(:conversation, session_id: session_id_2) }
    let!(:conversation_3) { create(:conversation, session_id: session_id_3) }

    it 'should return proper conversation instance' do
      expect(repository.find_by_session_id(session_id_1).id).to eq conversation_1.id
      expect(repository.find_by_session_id(session_id_2).id).to eq conversation_2.id
      expect(repository.find_by_session_id(session_id_3).id).to eq conversation_3.id
    end

    it 'should return nil with no existing session_id' do
      expect(repository.find_by_session_id('fake')).to eq nil
    end
  end
end
