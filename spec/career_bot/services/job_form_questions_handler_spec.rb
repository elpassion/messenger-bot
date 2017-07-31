describe JobFormQuestionsHandler do
  let(:questions_text) { I18n.t('questions', locale: :workable_form) }
  context 'simple questions' do
    it 'creates question text message' do
      question = { 'key' => 'first_name', 'type' => 'string' }

      message = described_class.new(question).question_message

      expect(message).to eq({ quick_replies: nil, text: questions_text[:first_name] })
    end

    it 'handles question message without translation' do
      question = { 'key' => 'home_address', 'type' => 'free_text' }

      message = described_class.new(question).question_message

      expect(message).to eq({ quick_replies: nil, text: 'Home address?' })
    end
  end

  context 'complex questions' do
    it 'creates question with text message and quick replies' do
      question = { 'body' => 'How would you describe your level of English?',
                   'type' => 'multiple_choice', 'id' => '1b617',
                   'choices' => [{ 'body' => 'Beginner', 'id' => '4eb7' },
                                 { 'body' => 'Intermediate', 'id' => '4eb8' },
                                 { 'body' => 'Proficient', 'id' => '4eb9' }] }

      message = described_class.new(question).question_message

      quick_replies = [{ :content_type => 'text', :title => 'Beginner', :payload => '4eb7' },
                       { :content_type => 'text', :title => 'Intermediate', :payload => '4eb8' },
                       { :content_type => 'text', :title => 'Proficient', :payload => '4eb9' }]
      expect(message).to eq({ text: question['body'], quick_replies: quick_replies })
    end

    it 'creates question with text message and boolean quick replies' do
      question = { 'body' => 'Are you available to work full time in Warsaw?',
                   'type' => 'boolean', 'id' => '20975' }

      message = described_class.new(question).question_message

      quick_replies = [{ :content_type => 'text', :title => 'Yes', :payload => 'true' },
                       { :content_type => 'text', :title => 'No', :payload => 'false' }]
      expect(message).to eq({ text: question['body'], quick_replies: quick_replies })
    end
  end
end
