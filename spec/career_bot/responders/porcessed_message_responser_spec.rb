describe ProcessedMessageResponder do
  let(:message_hash) { {'sender' => {'id' =>  messenger_id},
                        'timestamp' => 1503933164327,
                        'message' => message } }

  let(:message) { { 'mid' => 'mid.$cAAE9Omda6aFkWqwzJ1eKWbq719NM', 'seq' => 207062, 'text' => 'some text' , 'nlp' => {'entities' => @entities } } }

  let(:messenger_id) { '123' }

  subject(:responder) { described_class.new(message_hash)}
  before do
    allow(Bot).to receive(:deliver).and_return nil
  end

  describe '#send_message' do
    context 'when message not run any action' do
      it 'returns proper answer' do
        @entities = { 'are_you_girl' => [{'value' =>  'are you a girl',
                                           'type' =>  'value' }] }

        expect(responder.send_message).to eq [ I18n.t('are_you_girl', locale: :wit_entities) ]
      end

      it 'returns proper answer for another entity' do
        @entities = { 'can_dance' => [{ 'value' =>  'can you dance',
                                        'type' =>  'value' }] }

        expect(responder.send_message).to eq [ I18n.t('can_dance', locale: :wit_entities) ]
      end

      it 'returns proper long answer' do
        @entities = { 'help' => [{ 'value' =>  'Help me',
                                   'type' =>  'value' }] }

        expect(responder.send_message).to eq I18n.t('help', locale: :wit_entities)
      end
    end

    context 'when message run content action' do
      it 'returns joke as a first line' do
        @entities = { 'joke' => [{ 'value' =>  'Tell me a joke',
                                   'type' =>  'value' }] }

        expect(I18n.t('body', locale: :jokes).include?(responder.send_message.first)).to eq true
      end

      it 'returns proper answer for social network request' do
        @entities = { 'social_network' => [{ 'value' =>  'facebook',
                                   'type' =>  'value' }] }

        address = I18n.t('facebook', locale: :social_networks)
        expect(responder.send_message.last).to eq I18n.t('found', locale: :wit_entities, scope: :social_network, social_network: 'facebook', address: address)
      end
    end
  end
end