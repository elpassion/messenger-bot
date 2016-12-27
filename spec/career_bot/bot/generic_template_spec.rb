describe GenericTemplate do

  let(:attachment_hash){
    {
      type: 'template',
      payload: {
        template_type: 'generic',
        elements: []
      }
    }
  }

  before :each do
    allow_any_instance_of(WorkableService).to receive(:get_active_jobs).and_return []
  end

  describe '#attachment' do
    it 'returns proper response' do
      expect(subject.attachment).to eq attachment_hash
    end
  end
end
