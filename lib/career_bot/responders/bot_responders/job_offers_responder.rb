class JobOffersResponder < BotResponder
  def initialize(session_uid:, job_position:, **options)
    @session_uid = session_uid
    @job_position = job_position
    super(**options)
  end

  def response
    save_job_codes
    bot_deliver(text: attachment[:text])
    bot_deliver(attachment: GenericTemplate.new(attachment_jobs).to_hash)
    bot_deliver(text: I18n.t('text_messages.try_again'))
  end

  private

  attr_reader :session_uid, :job_position

  def attachment_jobs
    @attachment_jobs ||= attachment[:data]
  end

  def attachment
    @attachment ||= if matching_jobs.any?
                      {
                        data: matching_jobs,
                        text: I18n.t('text_messages.found_matching_jobs')
                      }
                    elsif matching_descriptions.any?
                      {
                        data: matching_descriptions,
                        text: I18n.t('text_messages.found_matching_descriptions')
                      }
                    else
                      {
                        data: WorkableService.new.get_jobs,
                        text: I18n.t('text_messages.no_jobs_found')
                      }
                    end
  end

  def save_job_codes
    return unless attachment_jobs
    repository.update(conversation.id, job_codes: job_codes)
  end

  def job_codes
    attachment_jobs.map { |job| job['shortcode'] }.join(',')
  end

  def matching_jobs
    job_repository.get_matching_jobs(job_position)
  end

  def matching_descriptions
    job_repository.get_matching_descriptions(job_position)
  end
end
