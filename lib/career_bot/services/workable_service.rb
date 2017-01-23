class WorkableService
  def get_active_jobs
    @active_jobs ||= get_jobs.select{|job| job['state'] == 'published'}
  end

  def get_job_details(shortcode)
    Nokogiri::HTML(job_description(shortcode)).css('li').map { |li| li.text }
  end

  def job_full_description(shortcode)
    client.job_details(shortcode)['full_description']
  end

  private

  def job_description(shortcode)
    client.job_details(shortcode)['requirements']
  end

  def get_jobs
    @jobs ||= client.jobs.data
  end

  def client
    @client ||= Workable::Client.new(api_key: ENV['WORKABLE_API_KEY'], subdomain: 'elpassion')
  end
end
