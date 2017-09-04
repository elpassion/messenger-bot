describe ResponseAction::GetSocialNetworkService do
  let(:message_hash) { {'sender' => {'id' =>  '123'},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => entities } } }

  let(:message_data) { MessageData.new(message_hash) }
  let(:entities) { { 'social_network' => [{ 'value' =>  @social_network,
                                            'type' =>  'value' }] } }

  subject { described_class.new(message_data) }

  describe '#responses' do
    it 'returns proper answer for facebook' do
      @social_network = 'facebook'

      address = I18n.t(@social_network, locale: :social_networks)
      expect(subject.responses).to eq I18n.t('found', locale: :wit_entities, scope: :social_network, social_network: @social_network, address: address)
    end

    it 'returns proper answer for snapchat' do
      @social_network = 'snapchat'

      expect(subject.responses).to eq I18n.t('not_found', locale: :wit_entities, scope: :social_network, social_network: @social_network)
    end
  end
end
