class JobOffersResponder
  def initialize(conversation:, job_keyword:)
    @conversation = conversation
    @job_keyword = job_keyword
  end

  def response
    responses = [{ text: attachment[:text] }]
    if attachment_jobs
      save_job_codes
      responses.concat([{ attachment: GenericTemplate.new(attachment_jobs).to_hash },
       { text: I18n.t('text_messages.try_again_1') },
       { text: I18n.t('text_messages.try_again_2') }])
    end

    responses
  end

  private

  attr_reader :conversation, :job_keyword

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
                    elsif matching_job_keywords
                      {
                        text: I18n.t('text_messages.found_matching_job_keywords')
                      }
                    else
                      {
                        data: WorkableService.new.get_jobs,
                        text: I18n.t('text_messages.no_jobs_found')
                      }
                    end
  end

  def save_job_codes
    repository.update(conversation.id, job_codes: job_codes)
  end

  def job_codes
    attachment_jobs.map { |job| job['shortcode'] }.join(',')
  end

  def matching_jobs
    JobRepository.new.get_matching_jobs(job_keyword)
  end

  def matching_descriptions
    JobRepository.new.get_matching_descriptions(job_keyword)
  end

  def matching_job_keywords
    I18n.t(:keywords, locale: :jobs).include? job_keyword
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
