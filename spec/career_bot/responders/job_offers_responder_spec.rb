describe JobOffersResponder do
  let(:job_position) { 'ruby' }
  let(:session_uid) { '123' }

  let!(:conversation) { create(:conversation, session_uid: session_uid)}
  let(:repository) { ConversationRepository.new}

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  before { subject.response }

  subject { described_class.new(conversation: conversation, job_keyword: job_position) }

  context 'when no matching jobs found' do
    let(:job_position) { 'fireman' }

    it 'returns proper text message' do
      expect(subject.response.first[:text]).to eq I18n.t('text_messages.no_jobs_found')
    end

    it 'returns all available job offers' do
      expect(subject.response[1][:attachment][:payload][:elements].size).to eq 9
    end

    it 'should set conversation job codes to all active job codes' do
      expect(conversation_job_codes).to eq JobRepository.new.active_job_codes
    end
  end

  context 'when matching keywords found' do
    let(:job_position) { 'android' }

    it 'return proper text message' do
      expect(subject.response.first[:text]).to eq I18n.t('text_messages.found_matching_job_keywords')
    end
  end

  context 'when found jobs with matching title' do
    let(:job_position) { 'account' }

    it 'returns proper text message' do
      expect(subject.response.first[:text]).to eq I18n.t('text_messages.found_matching_jobs')
    end

    it 'returns proper amount of job offers' do
      expect(subject.response[1][:attachment][:payload][:elements].size).to eq 1
    end

    it 'should set conversation job codes to matched titles' do
      expect(conversation_job_codes.size).to eq 1
    end
  end

  context 'when found job with matching description' do
    let(:job_position) { 'scrum' }

    it 'returns proper text message' do
      expect(subject.response.first[:text]).to eq I18n.t('text_messages.found_matching_descriptions')
    end

    it 'returns proper amount of job offers' do
      expect(subject.response[1][:attachment][:payload][:elements].size).to eq 4
    end

    it 'should set conversation job codes to matched description' do
      expect(conversation_job_codes.size).to eq 4
    end
  end

  def conversation_job_codes
    repository.find_by_session_uid(session_uid).job_codes.split(',')
  end
end
