describe MessengerResponseHandler do
  let(:job_requirements_response_messages) do
    [{ text: I18n.t('text_messages.job_requirements_info', position: 'Senior Ruby Developer') },
     { text: '- Focus on clean, SOLID code' },
     { text: '- Attention to detail' },
     { text: '- A knack for finding simple solutions to complex issues' },
     { text: '- Being skilled in software engineering' },
     { text: '- Proven track record of using Rails in commercial projects' },
     { text: I18n.t('text_messages.apply_for_job', job_url: 'https://elpassion.workable.com/jobs/51167',
                   position: 'Senior Ruby Developer',
                   application_url: 'https://elpassion.workable.com/jobs/51167/candidates/new') }]
  end

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  it 'handles requirements postback' do
    postback = MockPostback.new('requirements|AF3C224021')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(job_requirements_response_messages)
  end
end
