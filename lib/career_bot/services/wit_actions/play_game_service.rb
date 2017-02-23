class WitAction::PlayGameService < WitAction
  def call
    if number.nil?
      context['wrongParam'] = true
      context['notWon'] = nil
    elsif number == winning_number
      set_won_context
    else
      set_not_won_context
    end
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
  end

  def set_not_won_context
    context['notWon'] = number > winning_number ? 'bigger' : 'smaller'
    update_counter
  end

  def counter
    context['counter']
  end

  def update_counter
    context['counter'] = counter ? counter + 1 : 1
    update_context(context, session_uid)
  end
end
