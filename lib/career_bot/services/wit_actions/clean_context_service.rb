class WitAction::CleanContextService < WitAction
  def call
    update_context({})
    {}
  end
end
