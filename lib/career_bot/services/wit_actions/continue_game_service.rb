class WitAction::ContinueGameService < WitAction
  def call
    if answer && answer == 'yes'
      set_context_true 'continue'
      set_context_nil 'wrongParam'
    else
      set_context_true 'stop'
    end
    context
  end

  private

  def answer
    first_entity_value 'yes_no_answer'
  end
end
