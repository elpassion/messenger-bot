class WitResponder
  def initialize(request, response, **options)
    @request = request
    @response = response
    @bot_interface = options[:bot_interface] || FacebookMessenger.new
    @job_repository = options[:job_repository] || JobRepository.new
  end

  def send_response
    responses[context_key] || text_response
  end

  private

  attr_reader :request, :response, :bot_interface, :job_repository

  def responses
    {
      job_position: found_job_offers,
      about_us: show_about_us,
      main_menu: show_main_menu
    }
  end

  def text_response
    bot_deliver({ text: response['text'] })
  end

  def found_job_offers
    if job_position
      bot_deliver({text: attachment[:text]})
      bot_deliver({attachment: GenericTemplate.new(attachment[:data]).to_hash})
      bot_deliver({text: I18n.t('text_messages.try_again')})
    end
  end

  def bot_deliver(message)
    bot_interface.deliver(messenger_id, message)
  end

  def show_about_us
    bot_deliver({attachment: I18n.t('ABOUT_US', locale: :responses).first}) if about_us
  end

  def show_main_menu
    bot_deliver({attachment: I18n.t('WELCOME_PAYLOAD', locale: :responses).first}) if main_menu
  end

  def attachment
    if matching_jobs.any?
      { data: matching_jobs, text: I18n.t('text_messages.found_matching_jobs') }
    elsif matching_descriptions.any?
      { data: matching_descriptions, text: I18n.t('text_messages.found_matching_descriptions') }
    else
      { data: WorkableService.new.get_jobs, text: I18n.t('text_messages.no_jobs_found') }
    end
  end

  def matching_jobs
    job_repository.get_matching_jobs(job_position)
  end

  def matching_descriptions
    job_repository.get_matching_descriptions(job_position)
  end

  def messenger_id
    repository.find_by_session_uid(session_uid).messenger_id
  end

  def repository
    @repository ||= ConversationRepository.new
  end

  def context
    @context ||= request['context']
  end

  def context_key
    context.keys.first.to_sym
  end

  def job_position
    @job_position ||= context['job_position']
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
