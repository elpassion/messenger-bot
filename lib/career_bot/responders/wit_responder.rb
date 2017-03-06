class WitResponder
  def initialize(request, response, **options)
    @request = request
    @response = response
    @bot_interface = options[:bot_interface] || FacebookMessenger.new
    @job_repository = options[:job_repository] || JobRepository.new
  end

  def send_response
    if job_position
      found_job_offers
    elsif about_us
      show_about_us
    else
      text_response
    end
  end

  private

  attr_reader :request, :response, :bot_interface, :job_repository

  def text_response
    bot_deliver({ text: response['text'] })
  end

  def found_job_offers
    bot_deliver({ text: attachment[:text] })
    bot_deliver({ attachment: GenericTemplate.new(attachment[:data]).to_hash })
    bot_deliver({ text: I18n.t('text_messages.try_again') })
  end

  def bot_deliver(message)
    bot_interface.deliver(messenger_id, message)
  end

  def show_about_us
    bot_deliver({ attachment: I18n.t(about_us, locale: :responses)[0] })
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

  def job_position
    @job_position ||= context['job_position']
  end

  def session_uid
    @session_uid ||= request['session_id']
  end

  def about_us
    @about_us ||= context['about_us']
  end
end
