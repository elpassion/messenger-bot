class JobDetailsService
  def initialize(session_uid:, details:)
    @session_uid = session_uid
    @details = details
  end

  def response
    if job_codes_blank?
      no_available_jobs_response
    elsif job_codes.length == 1
      one_avialable_job_response
    else
      show_quick_responses
    end
  end

  private

  attr_reader :session_uid, :details

  def quick_replies(job_codes)
    job_codes.reduce([]) do |replies, code|
      replies << DetailsQuickResponse.new(code: code, details: details).reply
    end.compact
  end

  def no_available_jobs_response
    bot_deliver({text: I18n.t('text_messages.no_available_details')})
  end

  def one_avialable_job_response
    JobDetailsResponse.new(code).messages.each do |line|
      bot_deliver({text: line})
    end
  end

  def show_quick_responses
    bot_deliver(
      {
        text: 'Which offer would you like to check?',
        quick_replies: quick_replies(job_codes)
      }
    )
  end

  def job_codes_blank?
    job_codes.nil? || job_codes.empty?
  end

  def job_codes
    @job_codes ||= conversation.job_codes.split(',') if !conversation.job_codes.to_s.empty?
  end

  def code
    @code = "#{details}|#{job_codes.first}"
  end

  def bot_deliver(message)
    bot_interface.deliver(messenger_id, message)
  end

  def bot_interface
    @bot_interface ||= FacebookMessenger.new
  end

  def repository
    @repository ||= ConversationRepository.new
  end

  def messenger_id
    repository.find_by_session_uid(session_uid).messenger_id
  end

  def conversation
    repository.find_by_session_uid(session_uid)
  end
end
