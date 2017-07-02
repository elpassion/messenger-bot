require 'rake'
require 'hanami/rake_tasks'
require_relative 'config/environment'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
end

task :preload do
end

task send_notifications: :environment do
  SendNotificationsWorker.perform_async
end

task get_active_job_offers: :environment do
  SetActiveJobsWorker.perform_async
end
