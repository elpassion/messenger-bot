class MockRepository
  def initialize(matching_jobs, matching_descriptions)
    @matching_jobs = matching_jobs
    @matching_descriptions = matching_descriptions
  end

  def get_matching_jobs(_context)
    matching_jobs
  end

  def get_matching_descriptions(_context)
    matching_descriptions
  end

  private

  attr_reader :matching_jobs, :matching_descriptions
end
