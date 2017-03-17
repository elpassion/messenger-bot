class JobParser
  def initialize(shortcode)
    @shortcode = shortcode
  end

  def job_requirements
    parsed_requirements.css(requirement_separator).map(&:text)
  end

  def job_benefits
    parsed_benefits.css(benefits_separator).map(&:text)
  end

  def job_title
    job['title']
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

  private

  attr_reader :shortcode

  def requirement_separator
    separator(parsed_requirements)
  end

  def benefits_separator
    separator(parsed_benefits)
  end

  def separator(parsed_text)
    separator = 'li'
    separator << ' ul li' while parsed_text.css("#{separator} ul li").any?
    separator
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
