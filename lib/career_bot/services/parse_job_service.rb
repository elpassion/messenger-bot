class ParseJobService
  def initialize(shortcode)
    @shortcode = shortcode
  end

  def get_job_requirements
    Nokogiri::HTML(job['requirements']).css('li').map { |li| li.text }
  end

  def get_job_benefits
    Nokogiri::HTML(job_full_description.split('Benefits').last).css('li').map { |li| li.text }
  end

  def job_title
    job['title']
  end

  def job_full_description
    job['full_description']
  end

  def job_urls
    { job_url: job['url'], application_url: job['application_url'] }
  end

  private

  attr_reader :shortcode

  def job
    active_jobs.detect { |job| job['shortcode'] == shortcode }
  end

  def active_jobs
    WorkableService.new.get_jobs
  end
end
