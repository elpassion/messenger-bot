class MessageResponder
  def initialize(message)
    @message = message
  end

  def set_action
    case
      when message.text == 'test'
        message.reply(I18n.t('test_message'))
      when message.attachments && conversation.apply == false
        message.reply(I18n.t('attachment_response'))
        message.reply(gif_response)
      when message_data.apply
        run_apply_process
      when quick_reply && quick_reply != 'empty'
        run_postback
      else
        process_message
    end
  end

  private

  attr_reader :message
  def gif_response
    { attachment: { type: 'image',
                    payload: { url: GifService.new.random_gif_url } } }
  end

  def run_apply_process
    ApplyResponderWorker.perform_async(conversation_id, message_text, params)
  end

  def run_postback
    if quick_reply.split('|').first == 'apply'
      start_apply_process
    else
      PostbackResponder.new(message, postback_message).send_postback_messages
    end
  end

  def start_apply_process
    repository.update(conversation_id,
     question_index: 0, apply_job_shortcode: quick_reply.split('|').last)
    ApplyResponder.new(conversation_id, message_text, {}).response
  end

  def process_message
    MessengerResponderWorker.perform_async(message_hash)
    # HandleWitResponseWorker.perform_async(message_sender_id, message_text)
  end

  def postback_message
    PostbackResponse.new.message(quick_reply, message_sender_id)
  end

  def params
    { attachment_url: attachment_url, quick_reply: quick_reply }
  end

  def quick_reply
    @quick_reply ||= message.quick_reply
  end

  def attachment_url
    return unless message.attachments
    @attachment_url ||= message.attachments.first['payload']['url']
  end

  def message_text
    @message_text ||= message.text
  end

  def conversation_id
    @conversation_id ||= message_data.conversation_id
  end

  def message_sender_id
    @message_sender_id ||= message_data.sender_id
  end

  def repository
    @repository ||= message_data.repository
  end

  def message_data
    @message_data ||= MessageData.new(message_hash)
  end

  def message_hash
    @message_hash ||= message.messaging
  end

  def deliver_messages(messages)
    messages.each do |message|
      FacebookMessenger.new.deliver(message_sender_id, message)
    end
  end
end
