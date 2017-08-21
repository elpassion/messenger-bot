class JobDetailsResponder
  def initialize(conversation:, details:)
    @conversation = conversation
    @details = details
  end

  def set_response
    [responses].flatten(1)
  end

  private

  attr_reader :conversation, :details

  def responses
    case job_codes.length
      when 0 then no_available_jobs_response
      when 1 then one_available_job_response
      else show_quick_responses
    end
  end

  def show_quick_responses
    { text: I18n.t("text_messages.which_offer_#{detail}"),
      quick_replies: quick_replies }
  end

  def quick_replies
    job_codes.map do |code|
      job = JobRepository.new.get_job(code).first
      { content_type: 'text', title: "#{job['title']}",
        payload: "#{details}|#{code}"
      }
    end
  end

  def detail
    details == 'apply' ? 'apply' : 'check'
  end

  def no_available_jobs_response
    { text: I18n.t('text_messages.no_available_details') }
  end

  def job_codes
    @job_codes ||= conversation_job_codes & active_job_codes
  end

  def conversation_job_codes
    conversation.job_codes ? conversation.job_codes.split(',') : []
  end

  def one_available_job_response
    JobDetailsResponse.new(single_job_code_payload, conversation.messenger_id).messages
  end

  def single_job_code_payload
    @single_job_code = "#{details}|#{job_codes.first}"
  end

  def active_job_codes
    JobRepository.new.active_job_codes
  end
end
