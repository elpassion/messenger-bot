class WitActionsService
  def wit_actions
    [
      send,
      check_sentiment,
      clean_context,
      continue_game,
      get_job,
      get_social_network,
      get_user, play_game,
      start_game
    ].reduce(:merge)
  end

  private

  def send
    {
      send: lambda do |request, response|
        WitResponder.new(request, response).send_response
      end
    }
  end

  def check_sentiment
    {
      check_sentiment: lambda do |request|
        WitAction::CheckSentimentService.new(request: request).call
      end
    }
  end

  def clean_context
    {
      clean_context: lambda do |request|
        WitAction::CleanContextService.new(request: request).call
      end
    }
  end

  def continue_game
    {
      continue_game: lambda do |request|
        WitAction::ContinueGameService.new(request: request).call
      end
    }
  end

  def get_job
    {
      get_job: lambda do |request|
        WitAction::GetJobService.new(request: request).call
      end
    }
  end

  def get_social_network
    {
      get_social_network: lambda do |request|
        WitAction::GetSocialNetworkService.new(request: request).call
      end
    }
  end

  def get_user
    {
      get_user: lambda do |request|
        WitAction::GetUserService.new(request: request).call
      end
    }
  end

  def play_game
    {
      play_game: lambda do |request|
        WitAction::PlayGameService.new(request: request).call
      end
    }
  end

  def start_game
    {
      start_game: lambda do |request|
        WitAction::StartGameService.new(request: request).call
      end
    }
  end
end
