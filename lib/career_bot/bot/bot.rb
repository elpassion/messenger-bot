include Facebook::Messenger

Bot.on :message do |message|
  recipient_id = message.sender['id']

  SenderActionsResponder.new.respond(recipient_id, %w(mark_seen typing_on))
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  else
    MessageResponder.new(message).send
  end
end

Bot.on :postback do |postback|
  PostbackResponder.new(postback, PostbackResponse.new.message(postback.payload)).send
end
