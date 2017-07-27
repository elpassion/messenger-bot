class JobFormAnswersHandler
  def add_answer_to_repository
    if question['body']
      handle_complex_answer
    else
      updated_answers = text_answers.
        merge(question['key'] => set_text_answer_message).to_h

      repository.update(conversation.id, text_answers: updated_answers)
    end
  end

  private

  attr_reader :conversation, :question, :message, :params

  def initialize(conversation, question, message, params)
    @conversation = conversation
    @question = question
    @message = message
    @params = params
  end

  def handle_complex_answer
    updated_answers = complex_answers.merge(question['body'] => {
      reply: set_complex_answer_message,
      to_send: "{ \"question_key\": \"#{question['id']}\", #{build_answer} }"
    }).to_h

    repository.update(conversation.id, complex_answers: updated_answers)
  end

  def build_answer
    complex_answer_types[question['type'].to_sym]
  end

  def complex_answer_types
    {
      multiple_choice: "\"choices\": [\"#{params['quick_reply'] || message}\"]",
      boolean: "\"checked\": #{params['quick_reply'] || message}",
      free_text: "\"body\": \"#{set_complex_answer_message}\""
    }
  end

  def set_text_answer_message
    question_key = question['key'].to_sym
    if text_answers.key?(question_key)
      "#{text_answers[question_key]}; #{message}"
    else
      params['attachment_url'] || message
    end
  end

  def set_complex_answer_message
    question_body = question['body'].to_sym
    if question['type'] == 'free_text' && complex_answers.key?(question_body)
      complex_answers[question_body][:reply] + '; ' + message
    else
      message
    end
  end

  def text_answers
    @text_answers ||= conversation.text_answers
  end

  def complex_answers
    @complex_answers ||= conversation.complex_answers
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
