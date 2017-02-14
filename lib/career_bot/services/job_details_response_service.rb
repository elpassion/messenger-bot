class JobDetailsResponseService
  def initialize(payload)
    @payload = payload
  end

  def get_response
    response.merge(job_details)
  end

  private

  attr_reader :payload

  def response
    case details_kind
      when 'requirements'
        job_requirements_data
      when 'benefits'
        job_benefits_data
    end
  end

  def job_requirements_data
    {
      text: I18n.t('text_messages.job_requirements_info', position: job_title),
      data: ParseJobService.new(job_shortcode).get_job_requirements
    }
  end

  def job_benefits_data
    {
      text: I18n.t('text_messages.job_benefits_info'),
      data: ParseJobService.new(job_shortcode).get_job_benefits
    }
  end

  def job_details
    { job_title: job_title }.merge(job_urls)
  end

  def job_title
    ParseJobService.new(job_shortcode).job_title
  end

  def job_urls
    ParseJobService.new(job_shortcode).job_urls
  end

  def details_kind
    payload.split('|').first
  end

  def job_shortcode
    @job_shortcode ||= payload.split('|').last
  end
end
