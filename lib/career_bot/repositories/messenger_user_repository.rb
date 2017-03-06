class MessengerUserRepository
  def initialize(messenger_id:)
    @messenger_id =  messenger_id
  end

  def name
    user_data['first_name']
  end

  private

  attr_reader :messenger_id

  def user_request
    Faraday.get user_profile
  end

  def user_data
    JSON.parse(user_request.body)
  end

  def user_profile
    "https://graph.facebook.com/v2.6/#{messenger_id}"\
    "?fields=first_name&access_token=#{ENV['ACCESS_TOKEN']}"
  end
end
