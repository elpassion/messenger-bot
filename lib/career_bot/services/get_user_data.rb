class GetUserData
  def name
    user_data['first_name']
  end

  private

  attr_reader :messenger_id

  def initialize(messenger_id:)
    @messenger_id = messenger_id
  end

  def user_data
    JSON.parse(user_request.body)
  end

  def user_request
    Faraday.get(user_profile_url)
  end

  def user_profile_url
    I18n.t('facebook_urls.user_profile', messenger_id: messenger_id,
           access_token: ENV['ACCESS_TOKEN'])
  end
end

