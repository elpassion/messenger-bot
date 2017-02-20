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

  let(:welcome_payload_message) do
    [{ attachment: { type: 'template', payload: { template_type: 'button', text: I18n.t('text_messages.welcome_message'),
                                                  buttons: [{ type: 'postback', title: I18n.t('buttons.find_a_job'), payload: 'JOB_OFFERS' },
                                                            { type: 'postback', title: I18n.t('buttons.play_a_game'), payload: 'PLAY_A_GAME' },
                                                            { type: 'postback', title: I18n.t('buttons.about_us'), payload: 'ABOUT_US' }]}}}]
  end

  let(:about_us_message) do
    [{ attachment: { type: 'template', payload: { template_type: 'button', text: I18n.t('text_messages.about_us_text'),
                                                  buttons: [{ type: 'postback', title: I18n.t('buttons.company'), payload: 'COMPANY' },
                                                            { type: 'postback', title: I18n.t('buttons.people'), payload: 'PEOPLE' },
                                                            { type: 'postback', title: I18n.t('buttons.what_we_do'), payload: 'WHAT_WE_DO' }]}}}]
  end

  let(:what_we_do_message) do
    [{ attachment: { type: 'image', payload: {url: I18n.t('urls.projects_gif') } } },
     { text: I18n.t('text_messages.what_we_do_message') },
     { text: I18n.t('text_messages.see_more_message') }]
  end

  let(:company_message) do
    [{ attachment: { type: 'image', payload: { url: I18n.t('urls.company_gif') } } },
     { text: I18n.t('text_messages.social_media_links') }]
  end

  before do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      WorkableService.new.set_jobs
    end
  end

  it 'handles WELCOME_PAYLOAD postback' do
    postback = MockPostback.new('WELCOME_PAYLOAD')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(welcome_payload_message)
  end

  it 'handles JOB_OFFERS postback' do
    postback = MockPostback.new('JOB_OFFERS')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq([{ text: I18n.t('text_messages.job_offers_message') }])
  end

  it 'handles ABOUT_US postback' do
    postback = MockPostback.new('ABOUT_US')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(about_us_message)
  end

  it 'handles WHAT_WE_DO postback' do
    postback = MockPostback.new('WHAT_WE_DO')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(what_we_do_message)
  end

  it 'handles COMPANY postback' do
    postback = MockPostback.new('COMPANY')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(company_message)
  end

  it 'handles PEOPLE postback' do
    postback = MockPostback.new('PEOPLE')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq([{ text: I18n.t('text_messages.team_members_message') }])
  end

  it 'handles benefits postback' do
    postback = MockPostback.new('benefits|AF3C224021')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(job_benefits_response_messages)
  end

  it 'handles requirements postback' do
    postback = MockPostback.new('requirements|AF3C224021')
    described_class.new.handle_postback(postback)
    expect(postback.sent_messages).to eq(job_requirements_response_messages)
  end
end
