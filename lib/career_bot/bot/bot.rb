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

Bot.on :postback do |postback|
  if postback.payload == 'WELCOME_PAYLOAD'
    postback.reply(attachment:
     {
       type: 'template',
       payload: {
         template_type: 'button',
         text: 'This is el Passions career bot. What would you like to do?',
         buttons: [
           {
             type: 'postback',
             title: 'Show opened positions',
             payload: 'JOB_OFFERS'
           }
         ]
       }
     })
  elsif postback.payload == 'JOB_OFFERS'
    postback.reply(text: 'To be done')
  end
end
