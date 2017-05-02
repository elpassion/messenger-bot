describe JobRepository do

  let(:shortcode_1) { 'shortcode1' }
  let(:shortcode_2) { 'shortcode2' }
  let(:shortcode_3) { 'shortcode3' }
  let(:title_1) { 'Senior Ruby on Rails developer' }
  let(:title_2) { 'Ruby on Rails developer' }
  let(:title_3) { 'UX/UI designer' }
  let(:location) { 'Warsaw' }
  let(:active_jobs) {
    [
        {
            'title' => title_1,
            'shortcode' => shortcode_1,
            'location' => location,
            'full_description' => full_description_1,
            'requirements' => requirements_1
        },
        {
            'title' => title_2,
            'shortcode' => shortcode_2,
            'location' => location,
            'full_description' => full_description_1,
            'requirements' => requirements_1
        },
        {
            'title' => title_3,
            'shortcode' => shortcode_3,
            'location' => location,
            'full_description' => full_description_2,
            'requirements' => requirements_2
        }
    ]
  }

  let(:description) {
    'We are EL Passion, one of the leading software houses in Poland.
     Benefits<li>We offer clear and fair compensation system based entirely on thorough assessment of your skills. </li>
     <li>Salary range 10000 - 14600 PLN net</li> <li>IDE license, if you want one - you can choose your own editor</li>
    <li>You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!</li>
    <li>We practice TDD, write unit and functional tests; CI, CD, pair programming</li> <li>Work in a proper scrum :) No PMs, only direct work with the client. Take part in making key project decision</li>
    <li>Access to our resources library - books (paper and digital), courses, tutorials, assets. Choose whatever you’d like to have on our \"shelf\"!</li>
    <li>If you enjoy teaching become a mentor during our workshops or present an interesting topic at an internal meeting</li>'
  }

  let(:full_description_1) { description + requirements_1 }
  let(:full_description_2) { description + requirements_2 }

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

  before do
    allow_any_instance_of(WorkableService).to receive(:get_jobs).and_return(active_jobs)
  end

  subject { described_class.new }

  describe '#get_matching_jobs' do
    it 'should return proper jobs' do
      expect(subject.get_matching_jobs('ruby')).to eq [ active_jobs[0], active_jobs[1] ]
      expect(subject.get_matching_jobs('designer')).to eq [ active_jobs[2] ]
    end
  end

  describe '#get_matching_descriptions' do
    it 'should return proper jobs' do
      expect(subject.get_matching_descriptions('SOLID')).to eq [ active_jobs[0], active_jobs[1] ]
      expect(subject.get_matching_descriptions('wireframes')).to eq [ active_jobs[2] ]
    end
  end

  describe '#get_job' do
    it 'should return proper job' do
      expect(subject.get_job(shortcode_1)).to eq [ active_jobs.first ]
      expect(subject.get_job(shortcode_3)).to eq [ active_jobs.last ]
    end
  end

  describe '#active_job_codes' do
    it 'should return array of shortcodes' do
      expect(subject.active_job_codes).to eq [ shortcode_1, shortcode_2, shortcode_3 ]
    end
  end
end