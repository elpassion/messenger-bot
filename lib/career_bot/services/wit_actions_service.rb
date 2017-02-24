class WitActionsService
  def wit_actions
    [send, get_job, start_game, play_game, clean_context, continue_game].reduce(:merge)
  end

  private

  def send
    {
      send: -> (request, response) {
        context = request['context']['job_position']

        WitResponder.new(context, request['session_id'], response).send_response
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

  def continue_game
    {
      continue_game: -> (request) {
        WitAction::ContinueGameService.new(request: request).call
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
end
