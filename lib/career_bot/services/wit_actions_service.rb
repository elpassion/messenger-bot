class WitActionsService
  def wit_actions
    [send, clean_context, continue_game, get_job, get_social_network, get_user, play_game, start_game].reduce(:merge)
  end

  private

  def send
    {
      send: -> (request, response) {
        WitResponder.new(request, response).send_response
      }
    }
  end

  def clean_context
    {
      clean_context: -> (request) {
        WitAction::CleanContextService.new(request: request).call
      }
    }
  end

  def continue_game
    {
      continue_game: -> (request) {
        WitAction::ContinueGameService.new(request: request).call
      }
    }
  end

  def get_job
    {
      get_job: -> (request) {
        WitAction::GetJobService.new(request: request).call
      }
    }
  end

  def get_social_network
    {
      get_social_network: -> (request) {
        WitAction::GetSocialNetworkService.new(request: request).call
      }
    }
  end

  def get_user
    {
      get_user: -> (request) {
        WitAction::GetUserService.new(request: request).call
      }
    }
  end

  def play_game
    {
      play_game: -> (request) {
        WitAction::PlayGameService.new(request: request).call
      }
    }
  end

  def start_game
    {
      start_game: -> (request) {
        WitAction::StartGameService.new(request: request).call
      }
    }
  end
end
