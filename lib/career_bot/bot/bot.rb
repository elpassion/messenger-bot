include Facebook::Messenger

Bot.on :message do |message|
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  else
    message.type
    sender = message.sender
    client = WitConnection.instance.client
    client.run_actions(sender['id'], message.text, {})
  end
end

Bot.on :postback do |postback|
  payload = postback.payload
  case payload
    when 'WELCOME_PAYLOAD'
      buttons = [
        PostbackButton.new('I wanna find a job!', 'JOB_OFFERS').to_hash,
        PostbackButton.new('I wanna play a game!', 'PLAY_A_GAME').to_hash
      ]
      text = 'Hello! :) I am EL Passion Messenger Bot! What would you like to do?'
      postback.reply(attachment: ButtonTemplate.new(text).to_hash(buttons) )
    when 'JOB_OFFERS'
      postback.reply(text: 'Nice! :D Fortunately, we are looking for some cool people to join us! Sooo... What kind of job are you interested in?')
    when 'PLAY_A_GAME'
      postback.type
      sender = postback.sender
      client = WitConnection.instance.client
      client.run_actions(sender['id'], 'play_a_game', {})
    when 'TO_BE_DONE'
      postback.reply(text: 'TO BE DONE...')
    else
      response = ParseJobService.new(payload).get_job_details
      if response
        postback.reply(text: response)
      end
  end
end
