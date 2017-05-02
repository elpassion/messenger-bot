class JobRepository
  def get_matching_jobs(key_word)
    active_jobs.select do |job|
      title(job).include?(key_word) || location(job).include?(key_word)
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

  def title(job)
    job['title'].downcase
  end

  def location(job)
    I18n.transliterate(job['location'])
  end
end
