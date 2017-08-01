describe JobOffersResponder do
  let(:job_position) { 'ruby' }
  let(:context) { { 'job_position' => job_position } }
  let(:session_uid) { '123' }
  let(:bot_interface) { MockMessenger.new }
  let(:response) { ' ' }
  let(:request) {
    {
      'session_id' => session_uid,
      'context' => context,
      'entities' => {'number' => [{ 'type' => 'value', 'value' => 'ruby'}]}
    }
  }
  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:repository) { ConversationRepository.new}

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  before(:each) do
    subject.response
  end

  subject { described_class.new(session_uid: session_uid, job_keyword: job_position, job_repository: job_repository, bot_interface: bot_interface) }
  context 'when no matching jobs found' do
    let(:job_position) { 'php' }
    let(:job_repository) { MockRepository.new([], []) }

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.no_jobs_found')
    end

    it 'returns all available job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 9
    end

    it 'should set conversation job codes to all active job codes' do
      expect(conversation_job_codes).to eq JobRepository.new.active_job_codes
    end
  end

  context 'when matching keywords found' do
    let(:job_repository) { MockRepository.new([], []) }

    it 'return proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.found_matching_job_keywords')
    end
  end

  context 'when found two jobs with matching titles' do
    let(:job_repository) { MockRepository.new([{ 'shortcode' => '1234' }, { 'shortcode' => '2345' }], []) }

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.found_matching_jobs')
    end

    it 'returns proper amount of job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 2
    end

    it 'should set conversation job codes to matched titles' do
      expect(conversation_job_codes).to eq %w(1234 2345)
    end
  end

  context 'when found job with matching description' do
    let(:job_repository) { MockRepository.new([], [{ 'shortcode' => '1234' }]) }

    it 'returns proper text message' do
      expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.found_matching_descriptions')
    end

    it 'returns proper amount of job offers' do
      expect(bot_interface.sent_messages[1][:attachment][:payload][:elements].size).to eq 1
    end

    it 'should set conversation job codes to matched description' do
      expect(conversation_job_codes).to eq ['1234']
    end
  end

  def conversation_job_codes
    repository.find_by_session_uid(session_uid).job_codes.split(',')
  end

end
