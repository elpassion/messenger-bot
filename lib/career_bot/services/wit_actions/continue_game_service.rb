class WitAction::ContinueGameService < WitAction
  def call
    if answer == 'no'
      context['stop'] = true
    else
      context['continue'] = true
      context['wrongParam'] = nil
    end
    context
  end

  private

  def answer
    first_entity_value(request['entities'], 'yes_no_answer')
  end
end