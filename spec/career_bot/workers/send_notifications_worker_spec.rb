describe SendNotificationsWorker do
  let(:message) { 'Sample message' }
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it 'pushes jobs on to the queue' do
    expect { SendNotificationsWorker.perform_async(message) }
      .to change(SendNotificationsWorker.jobs, :size).by(1)
  end

  before do
    SendNotificationsWorker.perform_async(message)
  end

  it 'executes queued job' do
    expect { SendNotificationsWorker.drain }
      .to change(SendNotificationsWorker.jobs, :size).by(-1)
  end
end
