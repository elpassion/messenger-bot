class JobRepository
  def get_matching_jobs(key_word)
    active_jobs.select do |job|
      job['title'].downcase.include? key_word
    end
  end

  def get_matching_descriptions(key_word)
    active_jobs.select do |job|
      JobParser.new(job['shortcode']).job_full_description.include? key_word
    end
  end

  def get_job(shortcodes)
    active_jobs.select do |job|
      shortcodes.include? job['shortcode']
    end
  end

  def active_job_codes
    active_jobs.map { |job| job['shortcode'] }
  end

  private

  def active_jobs
    WorkableService.new.get_jobs
  end
end
