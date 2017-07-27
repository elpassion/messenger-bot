class SenderActionsResponder
  def respond(recipient_id, sender_actions)
    Array(sender_actions).each do |action|
      Bot.deliver({recipient: { id: recipient_id }, sender_action: action }, access_token: ENV['ACCESS_TOKEN'])
    end
  end
end
