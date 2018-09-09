class MessageResponder
  def initialize(message)
    @message = message
  end

  def response
    if message.text == 'test'
      message.reply(I18n.t('test_message'))
    elsif message_data.apply
      run_apply_process
    elsif message_attachments
      gif_response
    elsif quick_reply && quick_reply != 'empty'
      run_postback
    else
      process_message
    end
  end

  private

  attr_reader :message

  def gif_response
    message.reply(I18n.t('attachment_response'))
    message.reply(send_gif)
  end

  def send_gif
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
                      question_index: 0,
                      apply_job_shortcode: quick_reply.split('|').last)
    ApplyResponder.new(conversation_id, message_text, {}).response
  end

  def process_message
    MessengerResponderWorker.perform_async(message_hash)
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
    return unless message_attachments && message_attachments.first['payload']
    message_attachments.first['payload']['url']
  end

  def message_attachments
    @message_attachments ||= message.attachments
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
end
