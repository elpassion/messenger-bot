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
        PostbackButton.new('I wanna play a game!', 'PLAY_A_GAME').to_hash,
        PostbackButton.new('Tell me about ELP!', 'ABOUT_US').to_hash
      ]
      text = 'Hello! :) I am EL Passion Messenger Bot! What would you like to do?'
      postback.reply(attachment: ButtonTemplate.new(text).to_hash(buttons) )
    when 'JOB_OFFERS'
      postback.reply(text: 'Nice! :D Fortunately, we are looking for some cool people to join us! Sooo... What kind of job are you interested in?')
    when 'ABOUT_US'
      buttons = [
        PostbackButton.new('Company', 'COMPANY').to_hash,
        PostbackButton.new('People', 'PEOPLE').to_hash,
        PostbackButton.new('What we do?', 'WHAT_WE_DO').to_hash
      ]
      text = 'Cool! Which of those things you are interested in? :)'
      postback.reply(attachment: ButtonTemplate.new(text).to_hash(buttons))
      postback.reply(attachment: ButtonTemplate.new('Or maybe you want to go back to the beginning?').to_hash([PostbackButton.new('Yep! Beginning!', 'WELCOME_PAYLOAD').to_hash]))
    when 'PLAY_A_GAME'
      postback.type
      sender = postback.sender
      client = WitConnection.instance.client
      client.run_actions(sender['id'], 'play_a_game', {})
    when 'WHAT_WE_DO'
      postback.reply(attachment: {type: 'image', payload: {url: 'https://media.giphy.com/media/l3q2Chwola4nfdNra/source.gif'}})
      postback.reply(text: 'In EL Passion we create cool stuff, we use many fancy technologies!')
      postback.reply(text: 'Wanna see more? Check out our website! http://www.elpassion.com/projects/')
      postback.reply(attachment: ButtonTemplate.new('Like it?').to_hash([PostbackButton.new('Yep! Take me back.', 'ABOUT_US').to_hash]))
    when 'COMPANY'
      postback.reply(attachment: {type: 'image', payload: {url: 'https://media.giphy.com/media/l3q2FwrtK2lURaeeA/source.gif'}})
      postback.reply(text: 'Here are useful links! Our website: http://www.elpassion.com/, Facebook: https://www.facebook.com/elpassion, Dribbble: https://dribbble.com/elpassion and our Blog: https://blog.elpassion.com/')
      postback.reply(attachment: ButtonTemplate.new('Like it?').to_hash([PostbackButton.new('Yep! Take me back.', 'ABOUT_US').to_hash]))
    when 'PEOPLE'
      postback.reply(text: 'You can check our squad here: http://www.elpassion.com/about-us/')
      postback.reply(attachment: ButtonTemplate.new('Like it?').to_hash([PostbackButton.new('Yep! Take me back.', 'ABOUT_US').to_hash]))
    else
      response = ParseJobService.new(payload).get_job_requirements
      if response
        postback.reply(text: 'Want to get this job? Good! Here are some nice-to-have things:')
        response.first(5).each { |a| postback.reply(text: "- #{a}") }
      end
  end
end
