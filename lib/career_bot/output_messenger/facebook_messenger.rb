class FacebookMessenger
  def deliver(recipient_id, message)
    Bot.deliver({ recipient: { id: recipient_id }, message: message }, access_token: ENV['ACCESS_TOKEN'])
  end
end
