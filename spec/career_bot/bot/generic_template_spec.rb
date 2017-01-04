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

  subject { described_class.new([])}
  
  describe '#attachment' do
    it 'returns proper response' do
      expect(subject.to_hash).to eq attachment_hash
    end
  end
end
