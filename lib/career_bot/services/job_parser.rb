class JobParser
  def initialize(shortcode)
    @shortcode = shortcode
  end

  def job_requirements
    job_details(parsed_requirements)
  end

  def job_benefits
    job_details(parsed_benefits)
  end

  def job_title
    job['title']
  end

  def job_location
    job['location']
  end

  def job_full_description
    job['full_description']
  end

  def job_url
    job['url']
  end

  def application_url
    job['application_url']
  end

  def image_url
    job['image_url']
  end

  def job_questions
    job['questions']
  end

  def form_fields
    job['form_fields']
  end

  private

  attr_reader :shortcode

  def job_details(collection)
    collection.css('li').map(&:text)
  end

  def parsed_requirements
    Nokogiri::HTML(job['requirements'])
  end

  def parsed_benefits
    Nokogiri::HTML(job_full_description.split('Benefits').last)
  end

  def job
    active_jobs.detect { |job| job['shortcode'] == shortcode }
  end

  def active_jobs
    WorkableService.new.get_jobs
  end
end
