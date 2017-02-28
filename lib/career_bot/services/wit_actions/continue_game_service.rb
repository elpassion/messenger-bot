class WitAction::ContinueGameService < WitAction
  def call
    if answer == 'no'
      set_true 'stop'
    else
      set_true 'continue'
      set_nil 'wrongParam'
    end
    context
  end

  private

  def answer
    first_entity_value 'yes_no_answer'
  end
end
