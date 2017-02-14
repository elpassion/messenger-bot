describe JobDetailsResponseService do
  let(:requirements_payload) { 'requirements|AF3C224021' }
  let(:benefits_payload) { 'benefits|AF3C224021' }

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  context 'when requirements payload given' do
    let(:response) { described_class.new(requirements_payload).get_response }

    it 'has proper data structure' do
      expect(response[:job_title]).to eq 'Senior Ruby Developer'
      expect(response[:text]).to eq I18n.t('text_messages.job_requirements_info', position: 'Senior Ruby Developer')
      expect(response[:data].first).to eq 'Focus on clean, SOLID code'
      expect(response[:application_url]).to eq 'https://elpassion.workable.com/jobs/51167/candidates/new'
      expect(response[:job_url]).to eq 'https://elpassion.workable.com/jobs/51167'
    end
  end

  context 'when benefits payload given' do
    let(:response) { described_class.new(benefits_payload).get_response }

    it 'has proper data structure' do
      expect(response[:job_title]).to eq 'Senior Ruby Developer'
      expect(response[:text]).to eq I18n.t('text_messages.job_benefits_info')
      expect(response[:data].first).to eq 'We offer clear and fair compensation system based entirely on thorough assessment of your skills. '
      expect(response[:application_url]).to eq 'https://elpassion.workable.com/jobs/51167/candidates/new'
      expect(response[:job_url]).to eq 'https://elpassion.workable.com/jobs/51167'
    end
  end
end
