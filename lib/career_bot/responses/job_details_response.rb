class JobDetailsResponse
  def initialize(payload, sender_id = nil)
    @payload = payload
    @sender_id = sender_id
  end

  def messages
    if allowed_details_kind?
      details_kind == 'apply' ? apply_text_message : list_message
    else
      I18n.t('text_messages.something_went_wrong')
    end
  end

  private

  attr_reader :payload, :sender_id

  def list_message
    [text, data, apply_for_job_message].flatten
  end

  def apply_text_message
    repository.update(conversation.id, apply: true,
                      apply_job_shortcode: job_shortcode,
                      text_answers: {},
                      complex_answers:{} )
    "Are you ready to fill the form and apply for #{job_title} position? You have to do it in one take! Type yes to get started :)"
  end

  def text
    details[:text]
  end

  def data
    data_details.first(5).map { |element| "- #{element}" }
  end

  def apply_for_job_message
    if benefits_or_requirements?
      I18n.t('text_messages.apply_for_job',
             location: job_location, job_url: job_url, position: job_title)
    end
  end

  def details
    case details_kind
      when 'requirements'
        requirement_details_hash
      when 'benefits'
        benefits_details_hash
      when 'apply'
        apply_text_message
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
                   position: job_title, location: job_location),
      data: job.job_requirements
    }
  end

  def job_title
    job.job_title
  end

  def job_location
    job.job_location
  end

  def application_url
    job.application_url
  end

  def job_url
    job.job_url
  end

  def data_details
    details[:data] || []
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

  def benefits_or_requirements?
    %w(benefits requirements).include?(details_kind)
  end

  def allowed_details_kind?
    %w(apply benefits requirements).include?(details_kind)
  end

  def conversation
    repository.find_by_messenger_id(sender_id)
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end
