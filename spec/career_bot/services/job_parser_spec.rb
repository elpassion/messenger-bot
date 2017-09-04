describe JobParser do

  let(:job_code_1) { 'jobcode1' }
  let(:job_code_2) { 'jobcode2' }
  let(:title_1) { 'Ruby on Rails developer' }
  let(:title_2) { 'Frontend developer'}
  let(:parsed_job_1) { described_class.new(job_code_1) }
  let(:parsed_job_2) { described_class.new(job_code_2) }
  let(:job_url) { 'https://elpassion.workable.com/jobs/68398' }
  let(:application_url) { 'https://elpassion.workable.com/jobs/68398/candidates/new' }
  let(:image_url) { 'https://fake.image.address' }
  let(:form_fields) { [{'index' => 0, 'key' => 'first_name', 'type' => 'string', 'required' => true},
                 {'index' => 1, 'key' => 'last_name', 'type' => 'string', 'required' => true},
                 {'index' => 2, 'key' => 'email', 'type' => 'string', 'required' => true}]}
  let(:questions) { [ {'index'=>7,
                       'body'=>'Are you available to work full time in Warsaw?',
                       'type'=>'boolean',
                       'required'=>true,
                       'id'=>'20975'},
                      {'index'=>8,
                       'body'=>'Links to portfolio (e.g. personal page, GitHub):',
                       'type'=>'free_text',
                       'required'=>true,
                       'id'=>'4596d'} ] }
  let(:active_jobs) {
    [{'shortcode'=>job_code_1,
      'title' => title_1,
      'url' => job_url,
      'application_url' => application_url,
      'full_description'=>
        '"<p>We are EL Passion, one of the leading software houses in Poland. Our passionate team specializes in designing and developing
        stunning web, iOS and Android apps for clients all around the world. Among others, we are proud to have supported Wirtualna Polska,
        GoldenLine, ZnanyLekarz, Estimote, Rightmove and RWE</p><p>Currently we are looking for a <strong>Senior Ruby Developer</strong> to join our team.
        </p><p>We want to offer you a possibility of working with modern frameworks and tools. Join a team that is up to date with latest tech and recognizes the
        importance of code quality (daily code reviews, pair programming, continuous integration). Get on board and work with us on a variety of startup projects,
        learn and enjoy!</p>
        <p><strong>Benefits</strong></p>
        <ul>
          <li>We offer clear and fair compensation system based entirely on thorough assessment of your skills. </li>
          <li>Salary range 10000 - 14600 PLN net</li>
          <li>IDE license, if you want one - you can choose your own editor</li>
          <li>You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!</li>
          <li>We practice TDD, write unit and functional tests; CI, CD, pair programming</li>
          <li>Work in a proper scrum :) No PMs, only direct work with the client. Take part in making key project decision</li>
        </ul>"',
      'requirements'=>
         '<ul> <li>Focus on clean, SOLID code</li>
          <li>Attention to detail</li>
          <li>A knack for finding simple solutions to complex issues</li>
          <li>Being skilled in software engineering</li>
          <li>Proven track record of using Rails in commercial projects</li>
          <li>Hands-on knowledge of SQL</li>
          <li>Treating automated testing as a habit and something as natural as naming variables</li> </ul><p><br></p>',
      'image_url' => image_url,
      'form_fields' => form_fields,
      'questions' => questions },
      { 'shortcode' => job_code_2, 'title' => title_2 }]
  }

  before do
    allow_any_instance_of(described_class).to receive(:active_jobs).and_return active_jobs
  end

  describe '#job_title' do
    it { expect(parsed_job_1.job_title).to eq title_1 }
    it { expect(parsed_job_2.job_title).to eq title_2 }
  end

  describe '#job_requirements' do
    it 'should return proper formatted list when original list is not nested' do
      expect(parsed_job_1.job_requirements).to eq ['Focus on clean, SOLID code',
                                                 'Attention to detail',
                                                 'A knack for finding simple solutions to complex issues',
                                                 'Being skilled in software engineering',
                                                 'Proven track record of using Rails in commercial projects',
                                                 'Hands-on knowledge of SQL',
                                                 'Treating automated testing as a habit and something as natural as naming variables']
    end
  end

  describe '#job_benefits' do
    it 'should return proper benefits' do
      expect(parsed_job_1.job_benefits).to eq ['We offer clear and fair compensation system based entirely on thorough assessment of your skills. ',
                                               'Salary range 10000 - 14600 PLN net',
                                               'IDE license, if you want one - you can choose your own editor',
                                               'You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!',
                                               'We practice TDD, write unit and functional tests; CI, CD, pair programming',
                                               'Work in a proper scrum :) No PMs, only direct work with the client. Take part in making key project decision']
    end
  end

  describe '#job_url' do
    it { expect(parsed_job_1.job_url).to eq job_url }
  end

  describe '#application_url' do
    it { expect(parsed_job_1.application_url).to eq application_url }
  end

  describe '#image_url' do
    it { expect(parsed_job_1.image_url).to eq image_url }
  end

  describe '#form_fields' do
    it { expect(parsed_job_1.form_fields).to eq form_fields }
  end

  describe '#job_questions' do
    it { expect(parsed_job_1.job_questions).to eq questions }
  end
end
