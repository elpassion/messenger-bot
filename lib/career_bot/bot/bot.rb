include Facebook::Messenger

Bot.on :message do |message|
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  elsif message.quick_reply
    PostbackResponder.new(message, PostbackResponse.new.message(message.quick_reply)).send
  else
    WitService.new(message).send
  end
end

Bot.on :postback do |postback|
  PostbackResponder.new(postback, PostbackResponse.new.message(postback.payload)).send
end
