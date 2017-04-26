class WitAction::PlayGameService < WitAction
  def call
    set_context
    update_context(context)
    context
  end

  private

  def set_context
    if number.nil?
      set_wrong_param_context
    elsif number == winning_number
      set_won_context
    else
      set_not_won_context
    end
  end

  def number
    first_entity_value 'number'
  end

  def winning_number
    context['winningNumber']
  end

  def set_won_context
    set_context_value 'number', number
    set_context_true 'won'
    remove_from_context'notWon', 'wrongParam'
    update_counter
  end

  def set_not_won_context
    set_context_value 'notWon', not_won_status
    remove_from_context 'won', 'wrongParam'
    update_counter
  end

  def set_wrong_param_context
    set_context_true 'play', 'wrongParam'
    remove_from_context 'won', 'notWon'
  end

  def counter
    context['counter']
  end

  def update_counter
    set_context_value 'counter', new_counter_value
  end

  def not_won_status
    number < winning_number ? 'bigger' : 'smaller'
  end

  def new_counter_value
    counter ? counter + 1 : 1
  end
end
