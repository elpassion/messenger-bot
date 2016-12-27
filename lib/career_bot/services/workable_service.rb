class WorkableService
  def get_active_jobs
    @active_jobs ||= get_jobs.select{|job| job['state'] == 'published'}
  end

  private

  def get_jobs
    @jobs ||= client.jobs.data
  end

  def client
    @client ||= Workable::Client.new(api_key: ENV['WORKABLE_API_KEY'], subdomain: 'elpassion')
  end
end
