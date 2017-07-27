class WorkableService
  HANDLED_QUESTION_TYPES = %w(string file free_text).freeze
  REQUIRED_FIELDS = %w(first_name last_name email).freeze

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
        location: job_details(job)['location']['city'],
        full_description: job_full_description(job),
        requirements: job_details(job)['requirements'],
        image_url: get_image_url(job),
        form_fields: job_form_fields(job),
        questions: job_questions(job)
      }
    end
  end

  def get_active_jobs
    @active_jobs ||= client.jobs(state: 'published').data
  end

  def job_details(job)
    client.job_details(job['shortcode'])
  end

  def job_form_fields(job)
    form_with_required_fields(job).each_with_index.map do |question, index|
      { 'index' => index }.merge(question)
    end
  end

  def job_questions(job)
    job_application_form(job)['questions'].each_with_index.map do |question, index|
      { 'index' => job_form_fields(job).size + index }.merge(question)
    end
  end

  def form_with_required_fields(job)
    fields = required_fields + job_application_form(job)['form_fields']

    fields.select { |field| HANDLED_QUESTION_TYPES.include?(field['type']) }
  end

  def required_fields
    REQUIRED_FIELDS.map do |element|
      { 'key' => element, 'type' => 'string', 'required' => true }
    end
  end

  def job_full_description(job)
    job_details(job)['full_description']
  end

  def get_image_url(job)
    image_url(job) if parsed_image(job).any?
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

  def job_application_form(job)
    JSON.parse(get_application_form_request(job).body)
  end

  def get_application_form_request(job)
    conn.get do |req|
      req.url "/spi/v3/accounts/elpassion/jobs/#{job['shortcode']}/application_form"
      req.headers['Authorization']= "Bearer #{ENV['WORKABLE_API_KEY']}"
    end
  end

  def conn
    @conn ||= Faraday.new(url: 'https://www.workable.com')
  end
end
