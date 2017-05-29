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
    when :job_position
      found_job_offers
    when :about_us
      show_about_us
    when :offer_details
      show_details
    when :main_menu
      show_main_menu
    when :details
      show_details
    when :gif
      send_random_gif
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

  def found_job_offers
    JobOffersResponder.new(session_uid: session_uid,
                           job_keyword: job_position).response
  end

  def show_about_us
    bot_deliver(attachment: I18n.t('ABOUT_US', locale: :responses).first)
  end

  def show_main_menu
    bot_deliver(attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first)
  end

  def show_details
    JobDetailsResponder.new(session_uid: session_uid, details: details).set_response
  end

  def send_random_gif
    bot_deliver(attachment: { type: 'image', payload: { url: gif_url } } )
    bot_deliver(text: I18n.t('RANDOM_GIF', locale: :responses) )
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

  def job_position
    @job_position ||= context['job_position']
  end

  def details
    @details ||= context['details']
  end

  def session_uid
    @session_uid ||= request['session_id']
  end

  def context_key
    context.keys.first.to_sym if context.keys.any?
  end

  def context
    @context ||= request['context']
  end

  def gif_url
    GifService.new.random_gif_url
  end
end
