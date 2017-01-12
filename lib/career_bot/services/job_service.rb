class JobService

  def initialize(key_word)
    @key_word = key_word
  end

  def get_jobs
    active_jobs.select do |job|
      job['full_title'].downcase.include? key_word
    end
  end

  private

  attr_reader :key_word

  def active_jobs
    WorkableService.new.get_active_jobs
  end
end