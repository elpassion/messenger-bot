class FacebookMessenger
  def deliver(session_id, message)
    Bot.deliver({ recipient: { id: session_id }, message: message }, access_token: ENV['ACCESS_TOKEN'])
  end
end
