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
  case postback.payload
    when 'WELCOME_PAYLOAD'
      buttons = [
        PostbackButton.new('Develompent', 'TO_BE_DONE').to_hash,
        PostbackButton.new('Job Offers', 'JOB_OFFERS').to_hash,
        PostbackButton.new('About Us', 'TO_BE_DONE').to_hash
      ]
      text = 'Hello! I am EL Passion Messenger Bot! What would you like to talk about?'
      postback.reply(attachment: ButtonTemplate.new(text).to_hash(buttons) )
    when 'JOB_OFFERS'
      data = WorkableService.new.get_active_jobs
      postback.reply(attachment: GenericTemplate.new(data).to_hash)
    when 'TO_BE_DONE'
      postback.reply(text: 'TO BE DONE...')
  end
end
