class WorkableService
  def set_jobs
    Sidekiq.redis do |connection|
      connection.set('jobs', parsed_jobs.to_json)
    end
  end

  def get_jobs
    jobs = Sidekiq.redis { |connection| connection.get 'jobs' }
    JSON.parse(jobs)
  end

  private

  def parsed_jobs
    get_active_jobs.map do |job|
      {
        title: job['title'],
        shortcode: job['shortcode'],
        url: job['url'],
        application_url: job['application_url'],
        full_description: job_full_description(job),
        requirements: job_details(job)['requirements'],
        image_url: image_url(job)
      }
    end
  end

  def get_active_jobs
    @active_jobs ||= client.jobs(state: 'published').data
  end

  def job_details(job)
    client.job_details(job['shortcode'])
  end

  def job_full_description(job)
    job_details(job)['full_description']
  end

  def image_url(job)
    parsed_image(job).attr('src').value if offer_with_image?(job)
  end

  def parsed_image(job)
    Nokogiri::HTML(job_full_description(job)).css('img')
  end

  def offer_with_image?(job)
    parsed_image(job).attr('title').value.to_s == 'Ad Cover'
  end

  def client
    @client ||= Workable::Client.new(api_key: ENV['WORKABLE_API_KEY'], subdomain: 'elpassion')
  end
end
