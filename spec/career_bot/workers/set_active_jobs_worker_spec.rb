describe SetActiveJobsWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it 'pushes jobs on to the queue' do
    expect { SetActiveJobsWorker.perform_async }.to change(SetActiveJobsWorker.jobs, :size).by(1)
  end

  before { SetActiveJobsWorker.perform_async }

  it 'executes queued job' do
    VCR.use_cassette 'active_jobs' do
      Net::HTTP.get_response(URI('https://www.workable.com/spi/v3/accounts/elpassion/jobs?state=published'))
      expect{ SetActiveJobsWorker.drain }.to change(SetActiveJobsWorker.jobs, :size).by(-1)
    end
  end
end
