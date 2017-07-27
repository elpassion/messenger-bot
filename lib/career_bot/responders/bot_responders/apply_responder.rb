class ApplyResponder < BotResponder
  def initialize(conversation_id, message, params = {}, **options)
    @conversation_id = conversation_id
    @message = message
    @params = params
    super(**options)
  end

  def response
    check_if_quit_application_process
    save_question_answer
    handle_multi_lines_answer
  end

  private

  attr_reader :conversation_id, :message, :params

  def run_proper_scenario
    case
      when question_index == 0 && conversation.apply
        start_apply_process
      when question_index < questions_size && conversation.apply
        deliver_question
      when question_index == questions_size
        deliver_answers_summary
      when question_index == questions_size + 1
        post_candidate_answers
    end
  end

  def start_apply_process
    bot_deliver(text: I18n.t('apply_process.start'))
    deliver_question
  end

  def handle_multi_lines_answer
    if save_question? && previous_question['type'] == 'free_text'
      bot_deliver(text: I18n.t('apply_process.go_on'))
      save_question_answer
    else
      update_conversation_index
      run_proper_scenario
    end
  end

  def deliver_question
    bot_deliver(text: question_message[:text],
                quick_replies: question_message[:quick_replies])
    if current_question['type'] == 'free_text'
      bot_deliver(text: I18n.t('apply_process.multi_lines_allowed'))
    end
  end

  def save_question_answer
    if save_question?
      JobFormAnswersHandler.new(conversation, previous_question,
                                message, params).add_answer_to_repository
    end
  end

  def deliver_answers_summary
    WorkableApplicationHandler.new(conversation).deliver_answers_summary
  end

  def post_candidate_answers
    if send_user_responses?
      WorkableApplicationHandler.new(conversation).post_candidate_answers
    else
      bot_deliver(text: I18n.t('apply_process.responses_not_saved'))
    end

    clear_conversation_data
  end

  def update_conversation_index
    repository.update(conversation_id, question_index: question_index + 1)
  end

  def parsed_questions
    @parsed_questions ||= job.form_fields + job.job_questions
  end

  def questions_size
    @questions_size ||= parsed_questions.size
  end

  def job
    @job ||= JobParser.new(conversation.apply_job_shortcode)
  end

  def conversation
    @conversation ||= repository.find(conversation_id)
  end

  def question_index
    @question_index ||= conversation.question_index
  end

  def get_question(index)
    parsed_questions.select{ |key, value| key['index'] == index }.first
  end

  def current_question
    @current_question ||= get_question(question_index)
  end

  def previous_question
    @previous_question ||= get_question(question_index - 1)
  end

  def question_message
    @question_message ||=
      JobFormQuestionsHandler.new(current_question).question_message
  end

  def save_question?
    question_index.between?(1, questions_size) &&
      (params['attachment_url'] || !message_includes_any?(%w(skip next)))
  end

  def check_if_quit_application_process
    if message_includes_any?(%w(exit quit leave stop))
      clear_conversation_data
      bot_deliver(text: I18n.t('apply_process.quit'))
    end
  end

  def send_user_responses?
    params['quick_reply'] == 'true' ||
      message_includes_any?(%w(yes yep yeah tak sure))
  end

  def message_includes_any?(words_array)
    message && (message.downcase.split & words_array).any?
  end

  def clear_conversation_data
    repository.update(conversation_id, apply: false, question_index: 0,
                      text_answers: {}, complex_answers: {})
  end
end
