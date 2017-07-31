describe JobFormAnswersHandler do
  let(:conversation) { create(:conversation, question_index: 0,
    apply_job_shortcode: '123', text_answers: {}, complex_answers: {}) }
  let(:message) { 'Question answer' }
  let(:second_message) { 'Question answer no. 2' }
  let(:params_with_attachment) { { 'attachment_url' => 'attachment_url_path',
                                   'quick_reply' => nil } }

  context 'text answers' do
    it 'adds reply to question' do
      question = { 'key' => 'first_name', 'type' => 'string' }

      handler = described_class.new(conversation, question, message, {})
      conversation = handler.add_answer_to_repository

      expect(conversation.text_answers).to eq({ :first_name => message })
    end

    it 'adds multi-lined replies' do
      question = { 'key' => 'summary', 'label' => 'Summary', 'type' => 'free_text' }

      handler = described_class.new(conversation, question, message, {})
      conversation = handler.add_answer_to_repository

      expect(conversation.text_answers).to eq({ :summary => message })

      updated_handler = described_class.new(conversation, question, second_message, {})
      updated_conversation = updated_handler.add_answer_to_repository

      expect(updated_conversation.text_answers).to eq({ :summary => "#{message}; #{second_message}" })
    end

    it 'handles attachment replies' do
      question = { 'key' => 'resume', 'type' => 'file' }

      handler = described_class.new(conversation, question, nil, params_with_attachment)
      conversation = handler.add_answer_to_repository

      expect(conversation.text_answers).to eq({ :resume => params_with_attachment['attachment_url'] })
    end
  end

  context 'complex answers' do
    let(:params_with_quick_reply) { { 'attachment_url' => nil, 'quick_reply' => '4eb7' } }
    let(:params_with_boolean_reply) { { 'attachment_url' => nil, 'quick_reply' => 'true' } }

    it 'builds proper answer hash from quick reply' do
      question = { 'body' => 'How would you describe your level of English?',
                   'type' => 'multiple_choice', 'id' => '1b617',
                   'choices' => [{ 'body' => 'Beginner', 'id' => '4eb7' },
                                 { 'body' => 'Intermediate', 'id' => '4eb8' },
                                 { 'body' => 'Proficient', 'id' => '4eb9' }] }

      handler = described_class.new(conversation, question, 'Proficient', params_with_quick_reply)
      conversation = handler.add_answer_to_repository
      expected_output = { :'How would you describe your level of English?' =>
                           { :reply => 'Proficient', :to_send =>
                             "{ \"question_key\": \"1b617\", \"choices\": [\"4eb7\"] }" } }

      expect(conversation.complex_answers).to eq(expected_output)
    end

    it 'builds proper answer to boolean type question from quick reply' do
      question = { 'body' => 'Are you available to work full time in Warsaw?',
                   'type' => 'boolean', 'id' => '20975' }

      handler = described_class.new(conversation, question, 'Yes', params_with_boolean_reply)
      conversation = handler.add_answer_to_repository

      expected_output = { :'Are you available to work full time in Warsaw?' =>
                            { :reply => 'Yes', :to_send =>
                              "{ \"question_key\": \"20975\", \"checked\": true }" } }
      expect(conversation.complex_answers).to eq(expected_output)
    end

    it 'builds proper complex answers from multi-lined input' do
      question = { 'body' => 'Links to portfolio (e.g. personal page, GitHub):',
                   'type' => 'free_text', 'id' => '4596d' }

      handler = described_class.new(conversation, question, message, {})
      conversation = handler.add_answer_to_repository

      updated_handler = described_class.new(conversation, question, second_message, {})
      updated_conversation = updated_handler.add_answer_to_repository

      expected_output = { :'Links to portfolio (e.g. personal page, GitHub):' =>
                            { :reply => 'Question answer; Question answer no. 2',
                              :to_send => "{ \"question_key\": \"4596d\", \"body\": "\
                                "\"Question answer; Question answer no. 2\" }" } }
      expect(updated_conversation.complex_answers).to eq(expected_output)
    end
  end
end
