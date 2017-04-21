class JobDetailsResponse
  def initialize(payload)
    @payload = payload
  end

  def messages
    details_kind == 'apply' ? apply_text_message : list_message
  end

  private

  attr_reader :payload

  def list_message
    [text, data, apply_for_job_message].flatten
  end

  def apply_text_message
    I18n.t('text_messages.job_apply_info',
           position: job_title,
           application_url: application_url)
  end

  def text
    details[:text]
  end

  def data
    details[:data].first(5).map { |element| "- #{element}" }
  end

  def apply_for_job_message
    I18n.t('text_messages.apply_for_job',
           application_url: application_url,
           job_url: job_url,
           position: job_title)
  end

  def details
    case details_kind
    when 'requirements'
      requirement_details_hash
    when 'benefits'
      benefits_details_hash
    end
  end

  def benefits_details_hash
    {
      text: I18n.t('text_messages.job_benefits_info'),
      data: job.job_benefits
    }
  end

  def requirement_details_hash
    {
      text: I18n.t('text_messages.job_requirements_info',
                   position: job_title),
      data: job.job_requirements
    }
  end

  def job_title
    job.job_title
  end

  def application_url
    job.application_url
  end

  def job_url
    job.job_url
  end

  def job
    @job ||= JobParser.new(job_shortcode)
  end

  def details_kind
    payload.split('|').first
  end

  def job_shortcode
    @job_shortcode ||= payload.split('|').last
  end
end
