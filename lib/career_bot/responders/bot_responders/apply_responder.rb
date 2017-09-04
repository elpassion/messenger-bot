class ApplyResponder
  def initialize(conversation_id, message, params = {})
    @conversation_id = conversation_id
    @message = message
    @params = params
  end

  def response
    save_question_answer
    run_next_conversation_step
  end

  private

  attr_reader :conversation_id, :message, :params

  def save_question_answer
    if save_question?
      JobFormAnswersHandler.new(conversation, previous_question,
                                message, params).add_answer_to_repository
    end
  end

  def run_next_conversation_step
    if save_question? && previous_question['type'] == 'free_text'
      handle_multi_line_answer
    else
      update_conversation_index
      run_proper_scenario
    end
  end

  def handle_multi_line_answer
    deliver_messages(text: I18n.t('apply_process.go_on'))
    save_question_answer
  end

  def update_conversation_index
    repository.update(conversation_id, question_index: question_index + 1)
  end

  def run_proper_scenario
    case
      when stop_apply_process?
        quit_application_process
      when question_index == 0
        start_application_process
      when (question_index < questions_size)
        deliver_question
      when question_index == questions_size
        deliver_answers_summary
      when question_index == questions_size + 1
        post_candidate_answers
    end
  end

  def start_application_process
    repository.update(conversation.id, apply: true,
                      text_answers: {}, complex_answers:{} )
    deliver_messages(text: I18n.t('apply_process.start', job_title: job.job_title))
    deliver_question
  end

  def deliver_question
    deliver_messages(text: question_message[:text],
                     quick_replies: question_message[:quick_replies])
    if current_question['type'] == 'free_text'
      deliver_messages(text: I18n.t('apply_process.multi_lines_allowed'))
    end
  end

  def deliver_answers_summary
    WorkableApplicationHandler.new(conversation).deliver_answers_summary
  end

  def post_candidate_answers
    if send_user_responses?
      WorkableApplicationHandler.new(conversation).post_candidate_answers
    else
      deliver_messages(text: I18n.t('apply_process.responses_not_saved'))
    end

    clear_conversation_apply_data
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
      (params['attachment_url'] ||
        !message_includes_any?(I18n.t('apply_process.skip_keywords')))
  end

  def stop_apply_process?
    message_includes_any?(I18n.t('apply_process.quit_keywords'))
  end

  def quit_application_process
    clear_conversation_apply_data
    deliver_messages(text: I18n.t('apply_process.quit'))
  end

  def send_user_responses?
    params['quick_reply'] == 'true' ||
      message_includes_any?(I18n.t('apply_process.positive_keywords'))
  end

  def message_includes_any?(words_array)
    message && (message.downcase.split & words_array).any?
  end

  def clear_conversation_apply_data
    repository.update(conversation_id, apply: false, question_index: 0,
                      text_answers: {}, complex_answers: {})
  end

  def deliver_messages(message)
    FacebookMessenger.new.deliver(conversation.messenger_id, message)
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
