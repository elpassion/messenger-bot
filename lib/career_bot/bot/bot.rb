include Facebook::Messenger

Bot.on :message do |message|
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  else
    sender = message.sender
    client = WitConnection.instance.client
    client.run_actions(sender['id'], message.text, {})
  end
end
