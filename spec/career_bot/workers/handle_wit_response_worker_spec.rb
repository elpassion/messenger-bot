describe HandleWitResponseWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it 'pushes jobs on to the queue' do
    expect { HandleWitResponseWorker.perform_async }.to change(HandleWitResponseWorker.jobs, :size).by(1)
  end

  before do
    HandleWitResponseWorker.perform_async('123', 'ruby')
    allow_any_instance_of(Wit).to receive(:run_actions).and_return(true)
  end

  it 'executes queued job' do
    expect { HandleWitResponseWorker.drain }.to change(HandleWitResponseWorker.jobs, :size).by(-1)
  end
end
