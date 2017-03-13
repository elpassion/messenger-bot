describe CleanConversationContextWorker do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it 'pushes jobs on to the queue' do
    expect { CleanConversationContextWorker.perform_async }
      .to change(CleanConversationContextWorker.jobs, :size).by(1)
  end

  before { CleanConversationContextWorker.perform_async }

  it 'executes queued job' do
    expect{ CleanConversationContextWorker.drain }
        .to change(CleanConversationContextWorker.jobs, :size).by(-1)
  end
end
