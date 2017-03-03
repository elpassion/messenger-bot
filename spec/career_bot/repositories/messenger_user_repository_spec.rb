describe MessengerUserRepository do
  let(:messenger_id) { 'messenger_id' }
  let(:user_first_name) { 'Jane' }
  let(:facebook_user_data) {
    {
        'first_name' => user_first_name,
        'last_name' => 'Doe',
        'locale' => 'pl_PL',
        'timezone' => 1,
        'gender' => 'female'
    }
  }

  subject { described_class.new(messenger_id: messenger_id) }

  before do
    allow(subject).to receive(:user_data).and_return(facebook_user_data)
  end

  describe '#name' do
    it 'should return user name' do
      expect(subject.name).to eq user_first_name
    end
  end
end
