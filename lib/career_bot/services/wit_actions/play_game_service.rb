class WitAction::PlayGameService < WitAction
  def call
    if number.nil?
      set_wrong_param_context
    elsif number == winning_number
      set_won_context
    else
      set_not_won_context
    end
    update_context(context, session_uid)
    context
  end

  private

  def number
    first_entity_value(request['entities'], 'number')
  end

  def winning_number
    context['winningNumber']
  end

  def set_won_context
    context['won'] = true
    context['number'] = number
    context['notWon'] = nil
    update_counter
    context['wrongParam'] = nil
  end

  def set_not_won_context
    context['notWon'] = number > winning_number ? 'bigger' : 'smaller'
    context['wrongParam'] = nil
    update_counter
  end

  def set_wrong_param_context
    context['wrongParam'] = true
    context['notWon'] = nil
  end

  def counter
    context['counter']
  end

  def update_counter
    context['counter'] = counter ? counter + 1 : 1
  end
end
