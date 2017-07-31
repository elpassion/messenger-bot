describe JobDetailsResponder do

  let(:bot_interface) { MockMessenger.new }
  let(:shortcode_1) { 'shortcode1' }
  let(:shortcode_2) { 'shortcode2' }
  let(:shortcode_3) { 'shortcode3' }
  let(:title_1) { 'Senior Ruby on Rails developer' }
  let(:title_2) { 'Ruby on Rails developer' }
  let(:title_3) { 'UX/UI designer' }
  let(:details) { 'requirements'}
  let(:location) { 'Warsaw' }
  let(:application_url_1) { 'www.jobofer1.apply.com' }
  let(:application_url_2) { 'www.jobofer2.apply.com' }
  let(:application_url_3) { 'www.jobofer3.apply.com' }
  let(:active_jobs) {
    [
        {
            'title' => title_1,
            'shortcode' => shortcode_1,
            'full_description' => full_description,
            'location' => location,
            'requirements' => requirements_1,
            'application_url' => application_url_1
        },
        {
            'title' => title_2,
            'shortcode' => shortcode_2,
            'full_description' => full_description,
            'location' => location,
            'requirements' => requirements_1,
            'application_url' => application_url_2

  },
        {
            'title' => title_3,
            'shortcode' => shortcode_3,
            'full_description' => full_description,
            'location' => location,
            'requirements' => requirements_2,
            'application_url' => application_url_3

        }
    ]
  }

  let(:full_description) {
    'We are EL Passion, one of the leading software houses in Poland.
     Benefits<li>We offer clear and fair compensation system based entirely on thorough assessment of your skills. </li>
     <li>Salary range 10000 - 14600 PLN net</li> <li>IDE license, if you want one - you can choose your own editor</li>
    <li>You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!</li>
    <li>We practice TDD, write unit and functional tests; CI, CD, pair programming</li> <li>Work in a proper scrum :) No PMs, only direct work with the client. Take part in making key project decision</li>
    <li>Access to our resources library - books (paper and digital), courses, tutorials, assets. Choose whatever you’d like to have on our \"shelf\"!</li>
    <li>If you enjoy teaching become a mentor during our workshops or present an interesting topic at an internal meeting</li>'
  }

  let(:requirements_1) {
    '<ul> <li>Focus on clean, SOLID code</li>
    <li>Attention to detail</li> <li>A knack for finding simple solutions to complex issues</li>
    <li>Being skilled in software engineering</li>
    <li>Proven track record of using Rails in commercial projects</li>
    <li>Hands-on knowledge of SQL</li>
    <li>Treating automated testing as a habit and something as natural as naming variables</li>
    <li>Good working knowledge of JS / ES6</li>
    <li>Ability to communicate effectively with team and clients</li>'
  }

  let(:requirements_2) {
    '<li>+2 years experience holding a similar role and a case study portfolio to prove it</li>
    <li>Experience creating wireframes in Axure/ UX Pin/ Sketch or other</li>
    <li>Experience working with UX Patterns</li>
    <li>Experience with the UX research and analysis tools. Ability to analyse and draw useful conclusions from statistics (Google Analytics, HotJar)</li>
    <li>Experience with preparing and conducting usability tests and recommending improvements based on findings</li>'
  }

  let(:repository) { ConversationRepository.new }
  let(:session_uid) { 'session_uid' }
  let!(:conversation) { create(:conversation, session_uid: session_uid, job_codes: job_codes)}

  subject { described_class.new(session_uid: session_uid, details: details, bot_interface: bot_interface) }

  before do
    allow_any_instance_of(WorkableService).to receive(:get_jobs).and_return(active_jobs)
    allow_any_instance_of(ApplyResponder).to receive(:response).and_return(nil)
  end

  describe '#response' do

    before do
      subject.set_response
    end
    context 'when job_codes are empty' do
      let(:job_codes) { nil }
      it 'should return proper message' do
        expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.no_available_details')
      end
    end

    context 'when there is one job code' do
      context 'with valid job code' do
        let(:job_codes) { shortcode_1 }

        context 'when requesting for requirements' do

          it 'should return proper beginning of message' do
            expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.job_requirements_info', position: title_1, location: 'Warsaw')
          end

          it 'should return proper requirements' do
            expect(bot_interface.sent_messages[1][:text]).to eq "- #{parsed_requirements(requirements_1).first}"
            expect(bot_interface.sent_messages[2][:text]).to eq "- #{parsed_requirements(requirements_1)[1]}"
            expect(bot_interface.sent_messages[5][:text]).to eq "- #{parsed_requirements(requirements_1)[4]}"
          end

          it 'should return proper end of message' do
            expect(bot_interface.sent_messages.last[:text]).to eq I18n.t('text_messages.apply_for_job', job_url: nil,
                                                                         position: title_1, location: 'Warsaw',
                                                                         application_url: application_url_1)
          end
        end

        context 'when requesting for benefits' do
          let(:details) { 'benefits' }

          it 'should return proper beginning of message' do
            expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.job_benefits_info', position: title_1, location: 'Warsaw')
          end

          it 'should return proper requirements' do
            expect(bot_interface.sent_messages[1][:text]).to eq "- #{parsed_benefits(full_description).first}"
            expect(bot_interface.sent_messages[2][:text]).to eq "- #{parsed_benefits(full_description)[1]}"
            expect(bot_interface.sent_messages[5][:text]).to eq "- #{parsed_benefits(full_description)[4]}"
          end

          it 'should return proper end of message' do
            expect(bot_interface.sent_messages.last[:text]).to eq I18n.t('text_messages.apply_for_job', job_url: nil,
                                                                         position: title_1, location: 'Warsaw',
                                                                         application_url: application_url_1)
          end
        end

        context 'when applying for a job' do
          let(:details) { 'apply' }

          it 'should return proper message' do
            expect(bot_interface.sent_messages).to eq []

          end
        end
      end

      context 'with invalid job code' do
        let(:job_codes) { 'invalid' }

        it 'should return proper message' do
          expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.no_available_details')
        end
      end
    end

    context 'when there is more then one job code' do
      context 'with valid job codes' do
        let(:job_codes) { "#{shortcode_1},#{shortcode_2},#{shortcode_3}" }
        context 'when requesting for requirements' do
          it 'should display proper message' do
            expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.which_offer_check')
          end

          it 'should display quick replies' do
            expect(bot_interface.sent_messages.first.key?(:quick_replies)).to eq true
          end

          it 'should contains 3 quick replies' do
            expect(bot_interface.sent_messages.first[:quick_replies].length).to eq 3
          end
        end

        context 'when applying for a job' do
          let(:details) { 'apply' }

          it 'should display proper message' do
            expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.which_offer_apply')
          end

          it 'should display quick replies' do
            expect(bot_interface.sent_messages.first.key?(:quick_replies)).to eq true
          end

          it 'should contains 3 quick replies' do
            expect(bot_interface.sent_messages.first[:quick_replies].length).to eq 3
          end
        end
      end

      context 'when not all job codes are valid' do
        let(:job_codes) { "#{shortcode_1},invalid,#{shortcode_3},invalid2" }

        it 'should display proper message' do
          expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.which_offer_check')
        end

        it 'should display quick replies' do
          expect(bot_interface.sent_messages.first.key?(:quick_replies)).to eq true
        end

        it 'should contains 3 quick replies' do
          expect(bot_interface.sent_messages.first[:quick_replies].length).to eq 2
        end

        it 'should return proper quick replies titles' do
          expect(bot_interface.sent_messages.first[:quick_replies].first[:title]).to eq ("#{title_1} (#{location})")
          expect(bot_interface.sent_messages.first[:quick_replies].last[:title]).to eq ("#{title_3} (#{location})")
        end
      end

      context 'when only one job code is valid' do
        let(:job_codes) { "#{shortcode_1},invalid,invalid2" }

        it 'should not contain quick replies' do
          expect(bot_interface.sent_messages.first.key?(:quick_replies)).to eq false
        end

        it 'should contain proper message' do
          message = I18n.t('text_messages.job_requirements_info', position: title_1, location: 'Warsaw')
          expect(bot_interface.sent_messages.first[:text]).to eq message
        end
      end

      context 'when there is no valid job code' do
        let(:job_codes) { 'invalid,invalid2' }

        it 'should not contain quick replies' do
          expect(bot_interface.sent_messages.first.key?(:quick_replies)).to eq false
        end

        it 'should contain proper message' do
          expect(bot_interface.sent_messages.first[:text]).to eq I18n.t('text_messages.no_available_details')
        end
      end
    end
  end

  def parsed_requirements(requirements)
    Nokogiri::HTML(requirements).css('li').map { |li| li.text }
  end

  def parsed_benefits(benefits)
    Nokogiri::HTML(benefits.split('Benefits').last).css('li').map { |li| li.text }
  end
end
