include Facebook::Messenger

Bot.on :message do |message|
  recipient_id = message.sender['id']

  SenderActionsResponder.new.respond(recipient_id, %w(mark_seen typing_on))
  MessageResponder.new(message).set_action
end

Bot.on :postback do |postback|
  response = PostbackResponse.new.message(postback.payload, postback.sender['id'])
  PostbackResponder.new(postback, response).send
end
