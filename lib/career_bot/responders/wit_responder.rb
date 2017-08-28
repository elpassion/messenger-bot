# to remove after full refactor
class WitResponder
  def initialize(conversation, request, response)
    @conversation = conversation
    @request = request
    @response = response
  end

  def responses
    [set_responses].flatten(1)
  end

  private

  attr_reader :conversation, :request, :response

  def set_responses
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

    payload
  end

  def add_quick_replies(payload)
    payload[:quick_replies] = response['quickreplies'].map do |reply|
      { content_type: 'text', title: reply, payload: 'empty' }
    end
  end

  def send_error_message
    [{ attachment: I18n.t('text_messages.something_went_wrong')[0] },
    { text: I18n.t('text_messages.something_went_wrong')[1] }]
  end

  def context_key
    @context_key ||= context.keys.first.to_sym if context.keys.any?
  end

  def context
    @context ||= request['context']
  end
end
