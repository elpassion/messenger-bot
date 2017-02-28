describe WitAction::ContinueGameService do

  let(:session_uid) { 'session_id' }
  let(:context) { {'play'=>true, 'wrongParam'=>true, 'winningNumber'=>82} }
  let!(:conversation) { create(:conversation, session_uid: session_uid, context: context)}
  let(:request) {
    { 'session_id' => session_uid,
      'context' => context,
      'entities' => {'yes_no_answer'=>[{ 'type'=>'value', 'value'=>answer}]}
    }
  }

  let(:repository) { ConversationRepository.new }

  subject { described_class.new(request: request) }

  describe '#call' do
    context 'with yes answer' do
      let(:answer) { 'yes' }
      it 'updates conversation context' do
        expect {
          subject.call
        }.not_to change {
          repository.find(conversation.id).context
        }
      end

      it 'should return continue param with true value' do
        expect(subject.call['continue']).to eq true
      end

      it 'should return continue wrongParam with nil value' do
        expect(subject.call['wrongParam']).to eq nil
      end
    end

    context 'with no answer' do
      let(:answer) { 'no' }
      it 'updates conversation context' do
        expect {
          subject.call
        }.not_to change {
          repository.find(conversation.id).context
        }
      end

      it 'should return continue param with true value' do
        expect(subject.call['stop']).to eq true
      end
    end
  end
end
