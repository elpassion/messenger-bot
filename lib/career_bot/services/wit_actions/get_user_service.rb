class WitAction::GetUserService < WitAction
  def call
    set_context_value 'name', user_first_name
    context
  end

  private

  def user_first_name
    GetUserData.new(messenger_id: messenger_id).first_name
  end
end
