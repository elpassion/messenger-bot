class SetActiveJobs
  include Sidekiq::Worker

  def perform
    WorkableService.new.set_jobs
  end
end
