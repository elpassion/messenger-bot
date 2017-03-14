class DetailsQuickResponse
  def initialize(code:, details:)
    @code = code
    @details = details
  end

  def reply
    if job
      {
        content_type: 'text',
        title: job['title'],
        payload: payload
      }
    end
  end

  private

  attr_reader :code, :details

  def job
    JobRepository.new.get_job(code).first
  end

  def payload
    "#{details}|#{code}"
  end
end
