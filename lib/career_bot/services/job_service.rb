class JobService
  def initialize(key_word)
    @key_word = key_word
  end

  def get_jobs
    active_jobs.select do |job|
      job['title'].downcase.include? key_word
    end
  end

  def get_jobs_description
    active_jobs.select do |job|
      ParseJobService.new(job['shortcode']).job_full_description.include? key_word
    end
  end

  private

  attr_reader :key_word

  def active_jobs
    WorkableService.new.get_jobs
  end
end
