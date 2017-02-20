class MessengerResponseHandler
  def handle_postback(postback)
    PostbackResponder.new(postback, PostbackResponse.new.message(postback.payload)).send
  end
end
