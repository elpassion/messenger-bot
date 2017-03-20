class WitResponder < BotResponder
  def initialize(request, response, **options)
    @request = request
    @response = response
    super(**options)
  end

  def send_response
    responses[context_key] || text_response
  end

  private

  attr_reader :request, :response

  def responses
    {
      job_position: found_job_offers,
      about_us: show_about_us,
      offer_details: show_details,
      main_menu: show_main_menu
    }
  end

  def text_response
    bot_deliver(text: response['text']) unless details
  end

  def found_job_offers
    return unless job_position
    JobOffersResponder.new(session_uid: session_uid,
                           job_position: job_position).response
  end

  def show_about_us
    return unless about_us
    bot_deliver(attachment: I18n.t('ABOUT_US', locale: :responses).first)
  end

  def show_main_menu
    return unless main_menu
    bot_deliver(attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first)
  end

  def show_details
    return unless details
    JobDetailsResponder.new(session_uid: session_uid, details: details).response
  end

  def context
    @context ||= request['context']
  end

  def context_key
    context.keys.first.to_sym if context.keys.any?
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

  def about_us
    @about_us ||= context['about_us']
  end

  def main_menu
    @main_menu ||= context['main_menu']
  end
end
