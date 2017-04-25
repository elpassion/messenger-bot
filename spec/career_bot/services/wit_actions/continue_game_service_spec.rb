describe WitAction::ContinueGameService do

  let(:session_uid) { 'session_id' }
  let(:context) { {'play' => true, 'wrongParam' => true, 'winningNumber' => 82} }
  let!(:conversation) { create(:conversation, session_uid: session_uid, context: context) }
  let(:request) {
    {'session_id' => session_uid,
     'context' => context
    }
  }

  let(:repository) { ConversationRepository.new }

  subject { described_class.new(request: request) }

  it 'should return context without wrongParam attribute' do
    new_context = { :play=>true, :wrongParam=>true, :winningNumber=>82 }
    expect(subject.call).to eq new_context
  end
end
