class ResponseAction::GetUserService < ResponseAction
  private

  def data
    { name: user_first_name }
  end

  def value
    'text'
  end
end
