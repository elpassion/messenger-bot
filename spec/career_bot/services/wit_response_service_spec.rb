describe WitResponseService do
  let(:context) { 'ruby' }
  let(:session_id) { '123' }
  let(:bot_interface) { MockMessenger.new }
  let(:response) { ' ' }

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  context 'when no matching jobs found' do
    before(:each) do
      job_repository = MockRepository.new([], [])

      described_class.new(context, session_id, response, bot_interface: bot_interface, job_repository: job_repository).send_response
    end

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.no_jobs_found')
    end

    it 'returns all available job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 4
    end
  end

  context 'when found two jobs with matching titles' do
    before(:each) do
      job_repository = MockRepository.new([{}, {}], [])
      described_class.new(context, session_id, response, bot_interface: bot_interface, job_repository: job_repository).send_response
    end

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.found_matching_jobs')
    end

    it 'returns proper amount of job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 2
    end
  end

  context 'when found job with matching description' do
    before(:each) do
      job_repository = MockRepository.new([], [{}])
      described_class.new(context, session_id, response, bot_interface: bot_interface, job_repository: job_repository).send_response
    end

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.found_matching_descriptions')
    end

    it 'returns proper amount of job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 1
    end
  end
end
