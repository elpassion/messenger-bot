class WitAction::CleanContextService < WitAction
  def call
    update_context({}, session_uid)
    {}
  end
end
