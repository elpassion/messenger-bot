class ParseJobService

  def initialize(payload)
    @payload = payload
  end

  def get_job_details
    WorkableService.new.get_job_details(job_shortcode)
  end

  private

  attr_reader :payload

  def job_shortcode
    payload.split('|').last
  end
end
