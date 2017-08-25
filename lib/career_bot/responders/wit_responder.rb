# to remove after refactor
class WitResponder < BotResponder
  def initialize(request, response, **options)
    @request = request
    @response = response
    super(**options)
  end

  def send_response
    set_response
  end

  private

  attr_reader :request, :response

  def set_response
    case context_key
    when :error
      send_error_message
    else
      text_response
    end
  end

  def text_response
    payload = { text: response['text'] }
    add_quick_replies(payload) if response['quickreplies']

    bot_deliver(payload)
  end

  def add_quick_replies(payload)
    payload[:quick_replies] = response['quickreplies'].map do |reply|
      { content_type: 'text', title: reply, payload: 'empty' }
    end
  end

  def send_error_message
    bot_deliver(attachment: I18n.t('text_messages.something_went_wrong')[0])
    bot_deliver(text: I18n.t('text_messages.something_went_wrong')[1])
  end

  def context_key
    context.keys.first.to_sym if context.keys.any?
  end

  def context
    @context ||= request['context']
  end
end
