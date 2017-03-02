class WitAction::GetUserService < WitAction
  def call
    set_context_value 'name', name
    context
  end

  private

  def name
    user_data['first_name']
  end

  def user_request
    Faraday.get user_profile
  end

  def user_data
    JSON.parse(user_request.body)
  end

  def messenger_id
    conversation.messenger_id
  end

  def user_profile
    "https://graph.facebook.com/v2.6/#{messenger_id}"\
    '?fields=first_name,last_name,profile_pic,locale,'\
    "timezone,gender&access_token=#{ENV['ACCESS_TOKEN']}"
  end
end
