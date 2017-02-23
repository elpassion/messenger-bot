class WitAction::StartGameService < WitAction
  def call
    context['winningNumber'] = rand(1..100)
    context['play'] = true
    update_context(context, session_uid)
    context
  end
end