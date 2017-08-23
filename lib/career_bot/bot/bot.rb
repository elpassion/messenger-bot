include Facebook::Messenger

Bot.on :message do |message|
  message_data = MessageData.new(message.messaging)
  SenderActionsResponder.new.respond(message_data.sender_id, %w(mark_seen typing_on))

  case
    when message.text == 'test'
      message.reply(text: 'OK, I am working! <3')
    when message.attachments && message_data.apply == false
      message.reply(attachment: { type: 'image', payload: { url: GifService.new.random_gif_url } })
      message.reply(text: 'I love it! <3 Check this out! :D')
    else
      MessageResponder.new(message_data).set_action
  end
end

Bot.on :postback do |postback|
  response = PostbackResponse.new.message(postback.payload, postback.sender['id'])
  PostbackResponder.new(postback, response).send
end
