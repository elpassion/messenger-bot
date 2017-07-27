class JobFormQuestionsHandler < BotResponder
  def question_message
    { text: current_question_body,
      quick_replies: set_quick_replies }
  end

  private

  attr_reader :current_question

  def initialize(current_question)
    @current_question = current_question
  end

  def set_quick_replies
    case current_question_type
      when 'multiple_choice'
        choices_quick_replies(current_question['choices'])
      when 'boolean'
        I18n.t('boolean_postback', locale: :responses)
    end
  end

  def current_question_type
    @current_question_type ||= current_question['type']
  end

  def current_question_body
    @current_question_body ||= current_question['body'] || get_body_by_key
  end

  def get_body_by_key
    I18n.t("questions.#{current_question['key']}", locale: :workable_form)
  end

  def choices_quick_replies(choices)
    choices.map do |choice|
      { content_type: 'text', title: choice['body'], payload: choice['id'] }
    end
  end
end
