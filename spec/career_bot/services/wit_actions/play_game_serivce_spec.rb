describe WitAction::PlayGameService do

  let(:session_uid) { 'session_uid' }
  let(:context) { { 'play' =>  true, 'winningNumber' =>  winning_number } }
  let(:winning_number) { 79 }
  let!(:conversation) { create(:conversation, session_uid: session_uid, context: {play:  true, winningNumber: winning_number })}
  let(:user_value) { 5 }
  let(:request) {
    { 'session_id' => session_uid,
      'context' => context,
      'text' => user_value,
      'entities' => {'number' => [{ 'type' => 'value', 'value' => user_value}]}
    }
  }

  let(:repository) { ConversationRepository.new }
  subject { described_class.new(request: request) }

  describe '#call' do
    context 'with user value equal to winning number' do
      let(:user_value) { winning_number }

      it 'returns won status' do
        expect(subject.call['won']).to eq true
      end
    end

    context 'with user value not equal to winning number' do
      context 'with smaller value' do
        let(:user_value) { winning_number - 5 }

        it 'should return proper not won status' do
          expect(subject.call['notWon']).to eq 'smaller'
        end
      end

      context 'with greater value' do
        let(:user_value) { winning_number + 5 }

        it 'should return proper not won status' do
          expect(subject.call['notWon']).to eq 'bigger'
        end
      end
    end

    context 'when user value is empty' do
      let(:user_value) { nil }

      it 'should return wrong param status' do
        expect(subject.call['wrongParam']).to eq true
      end
    end
  end
end