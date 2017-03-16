describe WitAction::GetRandomAnswerService do

  let(:session_uid) { 'session_uid' }
  let(:request) {
    { 'session_id' => session_uid,
     'context' => {},
     'text' => 'Random text',
     'entities' => {}
    }
  }

  subject { described_class.new(request: request) }

  describe '#call' do
    it 'should return one of proper messages' do
      expect(I18n.t('text_messages.unrecognized').include?(subject.call['answer'])).to eq true
    end
  end
end
