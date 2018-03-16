describe ResponseAction::GetDetailsService do
  let(:message_hash) { {'sender' => {'id' =>  messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:messenger_id) { '123' }
  let!(:conversation) { create(:conversation, messenger_id: messenger_id) }
  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'offer_details' => [{ 'value' => 'requirements',
                                           'type' => 'value' }] } }
  let(:repository) { ConversationRepository.new }
  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, messenger_id: messenger_id, job_codes: '50E5C4179C')}

  subject { described_class.new(message_data) }

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  describe '#responses' do
    it 'returns proper response for requirements' do
      expect(subject.responses).to eq [ { text: 'Here are some must-have things for Ruby Developer in Warsaw:' },
                                        { text: '- Focus on clean, readable code' },
                                        { text: '- Attention to detail' },
                                        { text: '- Insistence on adhering to good programming practices' },
                                        { text: '- Having worked on least one commercial project in Rails' },
                                        { text: '- Being familiar with SQL beyond ActiveRecord ' },
                                        { text: 'To see full job offer visit https://elpassion.workable.com/jobs/636000. Want to be Ruby Developer in Warsaw? Type APPLY to start application process and see you at EL Passion! :)' }]
    end
  end
end
