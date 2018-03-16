class WorkableService
  HANDLED_QUESTION_TYPES = %w(string file free_text).freeze
  REQUIRED_FIELDS = %w(first_name last_name email).freeze

  def set_jobs
    Sidekiq.redis do |connection|
      connection.set('jobs', (still_active_jobs + parsed_jobs).to_json)
    end
  end

  def get_jobs
    fetched_jobs
  end

  private

  def parsed_jobs
    jobs_to_update.map do |job|
      {
        title: job['title'],
        shortcode: job['shortcode'],
        url: job['url'],
        application_url: job['application_url'],
        location: job_details(job['shortcode'])['location']['city'],
        full_description: job_full_description(job['shortcode']),
        requirements: job_details(job['shortcode'])['requirements'],
        image_url: get_image_url(job['shortcode']),
        form_fields: job_form_fields(job['shortcode']),
        questions: job_questions(job['shortcode'])
      }
    end
  end

  def job_details(job_shortcode)
    batched_jobs_details.detect { |job| job['shortcode'] == job_shortcode }
  end

  def job_application_form(job_shortcode)
    batched_jobs_application_form.detect { |job| job['shortcode'] == job_shortcode }
  end

  def batched_jobs_details
    @batched_jobs_details ||= workable_jobs_shortcodes.map { |shortcode| client.job_details(shortcode) }
  end

  def batched_jobs_application_form
    @batched_jobs_application_form ||= workable_jobs_shortcodes.map do |shortcode|
      { 'shortcode' => shortcode }.merge(client.job_application_form(shortcode))
    end
  end

  def job_form_fields(job_shortcode)
    form_with_required_fields(job_shortcode).each_with_index.map do |question, index|
      { 'index' => index }.merge(question)
    end
  end

  def job_questions(job_shortcode)
    job_application_form(job_shortcode)['questions'].each_with_index.map do |question, index|
      { 'index' => job_form_fields(job_shortcode).size + index }.merge(question)
    end
  end

  def form_with_required_fields(job_shortcode)
    fields = required_fields + job_application_form(job_shortcode)['form_fields']

    fields.select { |field| HANDLED_QUESTION_TYPES.include?(field['type']) }
  end

  def required_fields
    REQUIRED_FIELDS.map do |element|
      { 'key' => element, 'type' => 'string', 'required' => true }
    end
  end

  def job_full_description(job_shortcode)
    job_details(job_shortcode)['full_description']
  end

  def get_image_url(job_shortcode)
    image_url(job_shortcode) if parsed_image(job_shortcode).any?
  end

  def image_url(job_shortcode)
    parsed_image(job_shortcode).attr('src').value if offer_with_image?(job_shortcode)
  end

  def parsed_image(job_shortcode)
    Nokogiri::HTML(job_full_description(job_shortcode)).css('img')
  end

  def offer_with_image?(job_shortcode)
    parsed_image(job_shortcode).attr('title').value.to_s == 'Ad Cover'
  end

  def jobs_to_update
    active_jobs.reject { |job| fetched_jobs_shortcodes.include?(job['shortcode']) }
  end

  def still_active_jobs
    fetched_jobs.select { |job| workable_jobs_shortcodes.include?(job['shortcode']) }
  end

  def fetched_jobs
    jobs ||= Sidekiq.redis { |connection| connection.get 'jobs' }
    JSON.parse(jobs)
  end

  def fetched_jobs_shortcodes
    @fetched_jobs_shortcodes ||= fetched_jobs.map { |fetched_job| fetched_job['shortcode'] }
  end

  def workable_jobs_shortcodes
    @workable_jobs_shortcodes ||= active_jobs.map { |active_job| active_job['shortcode'] }
  end

  def active_jobs
    @active_jobs ||= client.jobs(state: 'published').data
  end

  def client
    @client ||= Workable::Client.new(api_key: ENV['WORKABLE_API_KEY'], subdomain: 'elpassion')
  end
end
