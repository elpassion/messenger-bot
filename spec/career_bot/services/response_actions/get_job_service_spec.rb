describe ResponseAction::GetJobService do
  let(:message_hash) { {'sender' => {'id' =>  messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:messenger_id) { '123' }
  let!(:conversation) { create(:conversation, messenger_id: messenger_id) }
  let(:message_data) { MessageData.new(message_hash) }

  let(:repository) { ConversationRepository.new }
  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, messenger_id: messenger_id, job_codes: 'AF3C224021')}

  let(:entities) { { 'position' => [{ 'value' => 'ruby',
                                      'type' => 'value' }] } }

  subject { described_class.new(message_data) }

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  describe '#responses' do
    it 'returns proper response for job offer' do
      expect(subject.responses.first[:text]).to eq I18n.t('text_messages.found_matching_jobs')
    end

    it 'returns proper amount of offers' do
      expect(subject.responses[1][:attachment][:payload][:elements].size).to eq 2
    end
  end
end
