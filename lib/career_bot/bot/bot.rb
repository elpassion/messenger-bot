include Facebook::Messenger

Bot.on :message do |message|
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  else
    sender_id = message.sender['id']
    client = WitConnection.instance.client
    client.run_actions(sender_id, message.text, {})
  end
end

Bot.on :postback do |postback|
  MessengerResponseHandler.new.handle_postback(postback)
end
