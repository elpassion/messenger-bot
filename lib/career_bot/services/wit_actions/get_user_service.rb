class WitAction::GetUserService < WitAction
  def call
    set_context_value 'name', user_first_name
    context
  end
end
