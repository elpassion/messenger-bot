describe WorkableService do
  describe '#get_active_jobs' do
    let(:job) { subject.get_jobs.first }

    before do
      VCR.use_cassette 'active_jobs' do
        Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
        subject.set_jobs
      end
    end

    it 'returns proper number of offers' do
      expect(subject.get_jobs.count).to eq 4
    end

    it 'has proper data structure' do
      expect(job).to have_key('title')
      expect(job).to have_key('url')
      expect(job).to have_key('shortcode')
      expect(job).to have_key('application_url')
      expect(job).to have_key('full_description')
    end
  end
end
