describe PostbackResponder do
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

  let(:job_benefits_response_messages) do
    [{ text: I18n.t('text_messages.job_benefits_info') },
     { text: '- We offer clear and fair compensation system based entirely on thorough assessment of your skills. ' },
     { text: '- Salary range 10000 - 14600 PLN net' },
     { text: '- IDE license, if you want one - you can choose your own editor' },
     { text: '- You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!' },
     { text: '- We practice TDD, write unit and functional tests; CI, CD, pair programming' },
     { text: I18n.t('text_messages.apply_for_job', job_url: 'https://elpassion.workable.com/jobs/51167',
                    position: 'Senior Ruby Developer',
                    application_url: 'https://elpassion.workable.com/jobs/51167/candidates/new') }]
  end

  let(:what_we_do_message) do
    [{ attachment: { type: 'image', payload: { url: 'https://media.giphy.com/media/l3q2Chwola4nfdNra/source.gif' } } },
     { text: 'In EL Passion we create cool stuff, we use many fancy technologies!' },
     { text: "Wanna see more? Check out our website! http://www.elpassion.com/projects/. Looking for a job? Type things you are good at and I will show you what we got! :)\n" }]
  end

  let(:company_message) do
    [{ attachment: { type: 'image', payload: { url: 'https://media.giphy.com/media/l3q2FwrtK2lURaeeA/source.gif' } } },
     { text: "Here are useful links! Our website: http://www.elpassion.com/, Facebook: https://www.facebook.com/elpassion, Dribbble: https://dribbble.com/elpassion and our Blog: https://blog.elpassion.com/\n" }]
  end

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  it 'handles WELCOME_PAYLOAD postback' do
    postback = MockPostback.new('WELCOME_PAYLOAD')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq([{ attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first }])
  end

  it 'handles JOB_OFFERS postback' do
    postback = MockPostback.new('JOB_OFFERS')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq([{ text: I18n.t('JOB_OFFERS', locale: :responses) }])
  end

  it 'handles ABOUT_US postback' do
    postback = MockPostback.new('ABOUT_US')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq([{ attachment: I18n.t('ABOUT_US', locale: :responses).first }])
  end

  it 'handles WHAT_WE_DO postback' do
    postback = MockPostback.new('WHAT_WE_DO')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq(what_we_do_message)
  end

  it 'handles COMPANY postback' do
    postback = MockPostback.new('COMPANY')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq(company_message)
  end

  it 'handles PEOPLE postback' do
    postback = MockPostback.new('PEOPLE')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq([{ text: I18n.t('PEOPLE', locale: :responses) }])
  end

  it 'handles benefits postback' do
    postback = MockPostback.new('benefits|AF3C224021')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq(job_benefits_response_messages)
  end

  it 'handles requirements postback' do
    postback = MockPostback.new('requirements|AF3C224021')
    described_class.new(postback, PostbackResponse.new.message(postback.payload)).send
    expect(postback.sent_messages).to eq(job_requirements_response_messages)
  end
end
