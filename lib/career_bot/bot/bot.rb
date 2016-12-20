include Facebook::Messenger

Bot.on :message do |message|
  message.reply(text: 'OK, I am working! <3')
end
