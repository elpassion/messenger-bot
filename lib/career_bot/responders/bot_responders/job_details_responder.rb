class JobDetailsResponder < BotResponder
  def initialize(session_uid:, details:, **options)
    @session_uid = session_uid
    @details = details
    super(**options)
  end

  def set_response
    if no_job_codes?
      no_available_jobs_response
    elsif job_codes.length == 1
      one_available_job_response
    else
      show_quick_responses
    end
  end

  private

  attr_reader :session_uid, :details

  def show_quick_responses
    bot_deliver(
      text: I18n.t("text_messages.which_offer_#{detail}"),
      quick_replies: quick_replies
    )
  end

  def quick_replies
    job_codes.map do |code|
      DetailsQuickResponse.new(code: code, details: details).reply
    end
  end

  def detail
    details == 'apply' ? 'apply' : 'check'
  end

  def no_available_jobs_response
    bot_deliver(text: I18n.t('text_messages.no_available_details'))
  end

  def one_available_job_response
    job_details_responses.each { |line| bot_deliver(text: line) }
  end

  def no_job_codes?
    job_codes.empty?
  end

  def job_codes
    @job_codes ||= conversation_job_codes & active_job_codes
  end

  def conversation_job_codes
    conversation.job_codes ? conversation.job_codes.split(',') : []
  end

  def job_details_responses
    Array(JobDetailsResponse.new(single_job_code_payload).messages)
  end

  def single_job_code_payload
    @single_job_code = "#{details}|#{job_codes.first}"
  end

  def active_job_codes
    JobRepository.new.active_job_codes
  end
end
