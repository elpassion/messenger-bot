class WitResponder
  def initialize(context, session_id, response, **options)
    @context = context
    @session_id = session_id
    @response = response
    @bot_interface = options[:bot_interface] || FacebookMessenger.new
    @job_repository = options[:job_repository] || JobRepository.new
  end

  def send_response
    context ? found_job_offers : text_response
  end

  private

  attr_reader :context, :session_id, :response, :bot_interface, :job_repository

  def text_response
    bot_deliver({ text: response['text'] })
  end

  def found_job_offers
    bot_deliver({ text: attachment[:text] })
    bot_deliver({ attachment: GenericTemplate.new(attachment[:data]).to_hash })
    bot_deliver({ text: I18n.t('text_messages.try_again') })
  end

  def bot_deliver(message)
    bot_interface.deliver(session_id, message)
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
    job_repository.get_matching_jobs(context)
  end

  def matching_descriptions
    job_repository.get_matching_descriptions(context)
  end
end
