describe WorkableService do

  let(:workable_client) { double('workable_client') }
  let(:workable_collection) { double('workable_collection', data: workable_api_response) }
  let(:workable_api_response){
    [
      {
        'id' => '93d1',
        'title' => 'Content Marketing Specialist',
        'full_title' => 'Content Marketing Specialist - Warsaw',
        'shortcode' => '32BD741385',
        'state' => 'archived',
        'url' => 'https://elpassion.workable.com/jobs/36607',
        'application_url' => 'https://elpassion.workable.com/jobs/36607/candidates/new',
        'shortlink' => 'https://elpassion.workable.com/j/32BD741385'
      },
      {
        'id' => 'ccb1',
        'title' => 'Senior Ruby / Elixir Developer',
        'full_title' => 'Senior Ruby / Elixir Developer - Warsaw',
        'shortcode' => 'AF3C224021',
        'state' => 'published',
        'url' => 'https://elpassion.workable.com/jobs/51167',
        'application_url' => 'https://elpassion.workable.com/jobs/51167/candidates/new',
        'shortlink' => 'https://elpassion.workable.com/j/AF3C224021'
      },
      {
        'id' => 'ccb4',
        'title' => 'Ruby / Elixir Developer',
        'full_title' => 'Ruby / Elixir Developer - Warsaw',
        'shortcode' => '133F00AAF8',
        'state' => 'published',
        'url' => 'https://elpassion.workable.com/jobs/51170',
        'application_url' => 'https://elpassion.workable.com/jobs/51170/candidates/new',
        'shortlink' => 'https://elpassion.workable.com/j/133F00AAF8'
      }
    ]
  }

  before :each do
    allow(Workable::Client).to receive(:new).and_return workable_client
    allow(workable_client).to receive(:jobs).and_return workable_collection
  end

  describe '#get_active_jobs' do
    it 'returns jobs offer where state is published' do
      expect(subject.get_active_jobs.first['state']).to eq 'published'
    end

    it 'returns proper number of offers' do
      expect(subject.get_active_jobs.count).to eq 2
    end

    it 'doesn\'t return offers where state is not published' do
      not_published = subject.get_active_jobs.select{ |offer| offer['state'] != 'published' }
      expect(not_published).to eq []
    end
  end
end
