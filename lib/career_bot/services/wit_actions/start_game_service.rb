class WitAction::StartGameService < WitAction
  def call
    set_value 'winningNumber', rand(1..100)
    set_true 'play'
    update_context(context, session_uid)
    context
  end
end
