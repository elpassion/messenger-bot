describe WitAction::PlayGameService do

  let(:session_uid) { 'session_uid' }
  let(:context) { { 'play' =>  true, 'winningNumber' =>  winning_number} }
  let(:winning_number) { 79 }
  let!(:conversation) {
    create(:conversation, session_uid: session_uid,
     context: {
         play:  true, winningNumber: winning_number
     })
  }
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

      it 'updates conversation context' do
        expect {
          subject.call
        }.to change {
          repository.find(conversation.id).context
        }
      end

      it 'should return proper context' do
        expect(subject.call).to include(
                                    'play' => true,
                                    'winningNumber' => winning_number,
                                    'won' => true,
                                    'number' => winning_number,
                                    'notWon' => nil,
                                    'wrongParam' => nil
                                  )
      end

      it 'should count turns properly' do
        session_uid = 'new_session_id'
        user_value = 1
        subject.call
        subject.call
        user_value = winning_number
        expect(subject.call['counter']).to eq 3
      end
    end

    context 'with user value not equal to winning number' do
      context 'with smaller value' do
        let(:user_value) { winning_number - 5 }

        it 'updates conversation context' do
          expect {
            subject.call
          }.to change {
            repository.find(conversation.id).context
          }
        end

        it 'should return proper not won status' do
          expect(subject.call).to include(
                                      'play' => true,
                                      'winningNumber' => winning_number,
                                      'notWon' => 'bigger',
                                      'wrongParam' => nil
                                    )
        end

      end

      context 'with greater value' do
        let(:user_value) { winning_number + 5 }

        it 'updates conversation context' do
          expect {
            subject.call
          }.to change {
            repository.find(conversation.id).context
          }
        end

        it 'should return proper not won status' do
          expect(subject.call).to include(
                                      'play' => true,
                                      'winningNumber' => winning_number,
                                      'notWon' => 'smaller',
                                      'wrongParam' => nil
                                    )
        end
      end
    end

    context 'when user value is empty' do
      let(:user_value) { nil }

      it 'updates conversation context' do
        expect {
          subject.call
        }.to change {
          repository.find(conversation.id).context
        }
      end

      it 'should return wrong param status' do
        expect(subject.call).to include(
                                  'play' => true,
                                  'winningNumber' => winning_number,
                                  'notWon' => nil,
                                  'wrongParam' => true
                                )
      end
    end
  end
end