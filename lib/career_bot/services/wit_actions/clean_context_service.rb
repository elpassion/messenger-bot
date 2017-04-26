class WitAction::CleanContextService < WitAction
  def call
    update_context({})
    context = {}
    context
  end
end
