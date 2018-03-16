describe JobDetailsResponse do
  let(:requirements_payload) { 'requirements|50E5C4179C' }
  let(:benefits_payload) { 'benefits|50E5C4179C' }
  let(:apply_payload) { 'apply|50E5C4179C' }
  let(:position) { 'Ruby Developer' }
  let(:sender_id) { '123123' }
  let(:job_requirements_response_messages) do
    [{ text: I18n.t('text_messages.job_requirements_info', position: 'Ruby Developer', location: 'Warsaw') },
     { text: '- Focus on clean, readable code' },
     { text:  '- Attention to detail' },
     { text: '- Insistence on adhering to good programming practices' },
     { text: '- Having worked on least one commercial project in Rails' },
     { text: '- Being familiar with SQL beyond ActiveRecord ' },
     { text: I18n.t('text_messages.apply_for_job', job_url: 'https://elpassion.workable.com/jobs/636000',
                    position: position, location: 'Warsaw') }]
  end
  let(:job_benefits_response_messages) do
    [{ text: I18n.t('text_messages.job_benefits_info') },
     { text: '- We offer clear and fair compensation system based entirely on a thorough assessment of your skills' },
     { text: '- Salary range 5800 - 10200 PLN net ' },
     { text: "- Choose your prefered editor. Get an IDE license, if you'd want one" },
     { text: '- You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!' },
     { text: '- We practice TDD, write unit and functional tests; CI, CD, pair programming' },
     { text: I18n.t('text_messages.apply_for_job', job_url: 'https://elpassion.workable.com/jobs/636000',
                    position: 'Ruby Developer', location: 'Warsaw',
                    application_url: 'https://elpassion.workable.com/jobs/636000/candidates/new') }]
  end

  let(:job_apply_response_message) { [] }

  before do
    create(:conversation, messenger_id: sender_id )
    allow_any_instance_of(ApplyResponder).to receive(:response).and_return(nil)
  end

  context 'when requirements payload given' do
    let(:messages) { described_class.new(requirements_payload).messages }

    it 'has proper data structure' do
      expect(messages).to eq(job_requirements_response_messages)
    end
  end

  context 'when benefits payload given' do
    let(:messages) { described_class.new(benefits_payload).messages }

    it 'has proper data structure' do
      expect(messages).to eq(job_benefits_response_messages)
    end
  end

  context 'when apply payload given' do
    let(:messages) { described_class.new(apply_payload, sender_id).messages }

    it 'has proper data structure' do
      expect(messages).to eq(job_apply_response_message)
    end
  end
end
