include Facebook::Messenger

Bot.on :message do |message|
  recipient_id = message.sender['id']
  conversation = ConversationRepository.new.find_by_messenger_id(recipient_id)

  SenderActionsResponder.new.respond(recipient_id, %w(mark_seen typing_on))
  if message.text == 'test'
    message.reply(text: 'OK, I am working! <3')
  elsif message.attachments && conversation.apply == false
    message.reply(attachment: { type: 'image', payload: { url: GifService.new.random_gif_url } })
    message.reply(text: 'I love it! <3 Check this out! :D')
  else
    MessageResponder.new(message).set_action
  end
end

Bot.on :postback do |postback|
  PostbackResponder.new(postback, PostbackResponse.new.message(postback.payload, postback.sender['id'])).send
end
