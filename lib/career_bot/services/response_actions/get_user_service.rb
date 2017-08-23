class ResponseAction::GetUserService < ResponseAction
  def data
    { name: user_first_name }
  end

  def value
    'text'
  end
end
