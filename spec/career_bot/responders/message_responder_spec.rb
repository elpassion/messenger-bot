describe MessageResponder do
  let(:bot_message) { instance_double('Facebook::Messenger::Incoming::Message',
                                  messaging: message_hash,
                                  text: text,
                                  attachments: attachments,
                                  quick_reply: quick_reply) }

  let(:message_hash) { {'sender' => {'id' =>  messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }
  let(:attachments) { false }
  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => text , 'nlp' => {'entities' => entities } } }
  let(:text) { nil }
  let(:quick_reply) { nil }
  let(:entities) { {} }

  let(:messenger_id) { '123' }

  let!(:conversation) { create(:conversation, messenger_id: messenger_id, apply: apply) }
  let(:apply) { false }

  let(:gif) { { url: 'www.fake-gif-url.com'} }

  before do
    allow_any_instance_of(GifService).to receive(:random_gif_url).and_return(gif)
  end

  subject { described_class.new(bot_message) }

  describe '#set_action' do
    context 'whit test input' do
      let(:text) { 'test' }

      it 'returns test answer' do
        expect(bot_message).to receive(:reply).with(I18n.t('test_message'))
        subject.set_action
      end
    end

    context 'with attachments' do
      let(:attachments) {
        [ { 'type': 'image' } ]
      }

      it 'returns proper text answer' do
        expect(bot_message).to receive(:reply).with(I18n.t('attachment_response'))
        expect(bot_message).to receive(:reply).with({ attachment: {type: 'image', payload: { url: gif } } })

        subject.set_action
      end
    end

    context 'when user is during application process' do
      let(:apply) { true }
      let(:text) { 'Name' }

      it 'runs apply responder worker' do
        expect {
          subject.set_action
        }.to change(ApplyResponderWorker.jobs, :size).by(1)
      end
    end

    context 'with quick replies' do

      before do
        VCR.use_cassette 'active_jobs' do
          Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
          WorkableService.new.set_jobs
        end
      end

      let(:quick_reply) { 'requirements|AF3C224021' }

      it 'returns proper job details' do
        expect(bot_message).to receive(:reply).with({ text: 'Here are some must-have things for Senior Ruby Developer in Warsaw:' })
        expect(bot_message).to receive(:reply).with({ text: '- Focus on clean, SOLID code' })
        expect(bot_message).to receive(:reply).with({ text: '- Attention to detail' })
        expect(bot_message).to receive(:reply).with({ text: '- A knack for finding simple solutions to complex issues' })
        expect(bot_message).to receive(:reply).with({ text: '- Being skilled in software engineering' })
        expect(bot_message).to receive(:reply).with({ text: '- Proven track record of using Rails in commercial projects' })
        expect(bot_message).to receive(:reply).with({ text: I18n.t('text_messages.apply_for_job', job_url: 'https://elpassion.workable.com/jobs/51167',
                                                                   position: 'Senior Ruby Developer', location: 'Warsaw',
                                                                   application_url: 'https://elpassion.workable.com/jobs/51167/candidates/new') } )

        subject.set_action
      end
    end

    context 'when process message' do
      context 'with random text' do

        let(:text) { 'Uncategorised message' }

        it 'runs HandleWitResponderWorker' do
          expect {
            subject.set_action
          }.to change(HandleWitResponseWorker.jobs, :size).by(1)
        end

      end

      context 'with wit entity' do
        let(:entities) { { 'are_you_girl' =>
                           [{ 'confidence' =>  0.97151860919363,
                              'value' =>  'are you a girl',
                              'type' =>  'value' }] } }

        it 'runs MessengerResponderWorker' do
          expect {
            subject.set_action
          }.to change(MessengerResponderWorker.jobs, :size).by(1)
        end
      end
    end
  end
end
