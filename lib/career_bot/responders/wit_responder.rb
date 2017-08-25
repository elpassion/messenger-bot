# to remove after refactor
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

  def found_job_offers
    JobOffersResponder.new(conversation: conversation,
                           job_keyword: job_position).response
  end

  def show_about_us
    [{ attachment: I18n.t('ABOUT_US', locale: :responses).first }]
  end

  def show_main_menu
    [{ attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first }]
  end

  def show_details
    JobDetailsResponder.new(conversation: conversation,
                            details: details).responses
  end

  def send_random_gif
    [{ attachment: { type: 'image', payload: { url: gif_url } } },
    { text: I18n.t('RANDOM_GIF', locale: :responses)[0] }]
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

  def job_position
    @job_position ||= context['job_position']
  end

  def details
    @details ||= context['details']
  end

  def context_key
    @context_key ||= context.keys.first.to_sym if context.keys.any?
  end

  def context
    @context ||= request['context']
  end

  def gif_url
    GifService.new.random_gif_url
  end
end
