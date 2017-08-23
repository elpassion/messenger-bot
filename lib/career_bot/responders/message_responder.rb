class MessageResponder
  def initialize(message_data)
    @message_data = message_data
  end

  def set_action
    case
      when message_data.apply
        run_apply_process
      when quick_reply && quick_reply != 'empty'
        run_postback
      else
        process_message
    end
  end

  private

  attr_reader :message_data

  def run_apply_process
    ApplyResponderWorker.perform_async(conversation_id, message_text, params)
  end

  def run_postback
    if quick_reply.split('|').first == 'apply'
      start_apply_process
    else
      PostbackResponder.new(message_data.message, postback_message)
        .send_postback_messages
    end
  end

  def start_apply_process
    repository.update(conversation_id,
     question_index: 0, apply_job_shortcode: quick_reply.split('|').last)
    ApplyResponder.new(conversation_id, message_text, {}).response
  end

  def process_message
    MessengerResponderWorker.perform_async(message_data.message)
    # HandleWitResponseWorker.perform_async(message_sender_id, message_text)
  end

  def postback_message
    PostbackResponse.new.message(quick_reply, message_sender_id)
  end

  def params
    { attachment_url: message_data.attachment_url, quick_reply: quick_reply }
  end

  def quick_reply
    @quick_reply ||= message_data.quick_reply
  end

  def conversation_id
    @conversation_id ||= message_data.conversation_id
  end

  def message_sender_id
    @message_sender_id ||= message_data.sender_id
  end

  def message_text
    @message_text ||= message_data.text
  end

  def repository
    @repository ||= message_data.repository
  end
end
