class JobRepository
  def get_matching_jobs(key_word)
    active_jobs.select do |job|
      job['title'].downcase.include? key_word
    end
  end

  def get_matching_descriptions(key_word)
    active_jobs.select do |job|
      ParseJobService.new(job['shortcode']).job_full_description.include? key_word
    end
  end

  private

  def active_jobs
    WorkableService.new.get_jobs
  end
end
