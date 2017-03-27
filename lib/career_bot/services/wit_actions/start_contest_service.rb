class WitAction::StartContestService < WitAction
  def call
    set_context_true 'contest'
    update_context(context)
    context
  end
end
