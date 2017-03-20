describe JobParser do

  let(:job_code_1) { 'jobcode1' }
  let(:job_code_2) { 'jobcode2' }
  let(:parsed_job_1) { described_class.new(job_code_1) }
  let(:parsed_job_2) { described_class.new(job_code_2) }
  let(:active_jobs) {
    [{'shortcode'=>job_code_1,
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
          <li>Treating automated testing as a habit and something as natural as naming variables</li> </ul><p><br></p>'},
     {'shortcode'=>job_code_2,
      'url'=>'https://elpassion.workable.com/jobs/444731',
      'full_description'=>
        '"<p>We are EL Passion, one of the leading software houses in Poland. Our passionate team specializes in designing and developing stunning web,
        iOS and Android apps for clients all around the world. Among others, we are proud to have supported Wirtualna Polska, GoldenLine, ZnanyLekarz,
        Estimote, Rightmove and RWE.</p><p>Currently we are looking for a <strong>Senior </strong><strong>Node.js Developer </strong>to join our team. </p>
        <p>We want to offer you a possibility of working with modern frameworks and tools. Join a team that is up to date with latest tech and recognizes
        the importance of code quality (daily code reviews, pair programming, continuous integration). Get on board and work with us on a variety of startup projects,
        learn and enjoy!</p>
        <p><strong>Benefits</strong></p>
        <ul>
          <li>We offer clear and fair compensation system based entirely on thorough assessment of your skills. </li>
          <li>Salary range 10000 - 14600 PLN net</li>
          <li>IDE license, if you want one - you can choose your own editor</li>
          <li>You decide which technology will be most appropriate for your project. Want to try something new? - Great, we love to experiment!</li>
          <li>We practice TDD, write unit and functional tests; CI, CD, pair programming</li>
          <li>Work in a proper scrum :) No PMs, only direct work with the client. Take part in making key project decision</li>
        </ul>',
      'requirements'=>
         '<ul>
            <li> <strong>Must have</strong>
              <ul>
                <li>JavaScript / ES6</li>
                <li>Node.js</li>
                <li>Node.js Frameworks</li>
                <li>Express</li>
                <li>Clean Code</li>
                <li>Databases</li>
                <li>Tests</li>
              </ul>
            </li>
            <li> <strong>Nice to have</strong>
              <ul>
                <li>TDD</li>
                <li>REST</li>
                <li>Other programming languages</li>
              </ul>
            </li>
          </ul>'}
    ]
  }

  before do
    allow_any_instance_of(described_class).to receive(:active_jobs).and_return active_jobs
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

    it 'should return proper formatted list when original list is nested' do
      expect(parsed_job_2.job_requirements).to eq ['JavaScript / ES6',
                                                   'Node.js',
                                                   'Node.js Frameworks',
                                                   'Express',
                                                   'Clean Code',
                                                   'Databases',
                                                   'Tests',
                                                   'TDD',
                                                   'REST',
                                                   'Other programming languages']
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
end
