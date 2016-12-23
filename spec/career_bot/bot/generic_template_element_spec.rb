describe GenericTemplateElement do

  let(:offer) {
    {
      'id' => '93d1',
      'title' => 'Content Marketing Specialist',
      'full_title' => 'Content Marketing Specialist - Warsaw',
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
      image_url: 'https://workablehr.s3.amazonaws.com/uploads/account/logo/13617/large_logo_elpasison_v1.1.png',
      subtitle: 'Content Marketing Specialist - Warsaw',
      default_action: {
        type:'web_url',
        url: 'https://elpassion.workable.com/jobs/36607'
      },
      buttons: [
        { type: 'web_url', url: 'https://elpassion.workable.com/jobs/36607', title: 'View offer'},
        { type: 'web_url', url: 'https://elpassion.workable.com/jobs/36607', title: 'View offer'}
      ]
    }
  }

  subject { described_class.new(offer) }
  describe '#element' do
    it 'returns proper response' do
      expect(subject.element).to eq element_hash
    end
  end
end
