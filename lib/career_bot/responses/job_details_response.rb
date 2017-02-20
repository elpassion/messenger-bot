class JobDetailsResponse
  def initialize(payload)
    @payload = payload
  end

  def messages
    [text, data, apply_for_job_message].flatten
  end

  private

  attr_reader :payload

  def text
    details[:text]
  end

  def data
    details[:data].first(5).map { |element| "- #{element}" }
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

  def apply_for_job_message
    I18n.t('text_messages.apply_for_job', job_url: job_url, position: job_title,
           application_url: application_url)
  end

  def details
    case details_kind
      when 'requirements'
        {
          text: I18n.t('text_messages.job_requirements_info', position: job_title),
          data: job.job_requirements
        }
      when 'benefits'
        { text: I18n.t('text_messages.job_benefits_info'), data: job.job_benefits }
    end
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
