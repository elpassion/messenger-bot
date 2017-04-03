include Facebook::Messenger

Bot.on :message do |message|
  recipient_id = message.sender['id']

  sender_actions_responder.respond(recipient_id, %w(mark_seen typing_on))
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  else
    MessageResponder.new(message).send
  end
  sender_actions_responder.respond(recipient_id, 'typing_off')
end

Bot.on :postback do |postback|
  PostbackResponder.new(postback, PostbackResponse.new.message(postback.payload)).send
end

private

def sender_actions_responder
  @sender_actions_responder ||= SenderActionsResponder.new
end
