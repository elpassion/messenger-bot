describe GenericTemplateElement do

  let(:offer) {
    {
      'id' => '93d1',
      'title' => 'Content Marketing Specialist',
      'location' => 'Warsaw',
      'shortcode' => '32BD741385',
      'state' => 'archived',
      'url' => 'https://elpassion.workable.com/jobs/36607',
      'application_url' => 'https://elpassion.workable.com/jobs/36607/candidates/new',
      'shortlink' => 'https://elpassion.workable.com/j/32BD741385'
    }
  }

  let(:element_hash) {
    {
      title: 'Content Marketing Specialist',
      subtitle: 'Warsaw',
      default_action: {
        type:'web_url',
        url: 'https://elpassion.workable.com/jobs/36607'
      },
      buttons: [
        { type: 'postback', title: 'Apply for offer', payload: 'apply|32BD741385' },
        { type: 'postback', title: 'Show requirements', payload: 'requirements|32BD741385' },
        { type: 'postback', title: 'Show benefits', payload: 'benefits|32BD741385' }
      ]
    }
  }

  subject { described_class.new(offer) }
  describe '#element' do
    it 'returns proper response' do
      expect(subject.to_hash).to include element_hash
    end
  end
end
