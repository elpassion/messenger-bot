class WitAction::StartGameService < WitAction
  def call
    set_context_value 'winningNumber', rand(1..100)
    set_context_true 'play'
    update_context(context)
    context
  end
end
