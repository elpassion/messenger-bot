class WitAction::GetYesNoAnswerService < WitAction
  def call
    y_n_answer == 'yes' ? set_context_true('continue') : set_context_true('stop')
    context
  end

  private

  def y_n_answer
    first_entity_value 'y_n_answer'
  end
end
