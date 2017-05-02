class WitActionsService
  def wit_actions
    [check_sentiment, clean_context, continue_game, get_details, get_job,
     get_random_answer, get_social_network, get_user, play_game, show_about_us,
     send, show_main_menu, start_game, start_contest, get_contest_answer,
     send_random_gif, get_yes_no_answer].reduce(:merge)
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

  def get_details
    {
      get_details: lambda do |request|
        WitAction::GetDetailsService.new(request: request).call
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

  def get_random_answer
    {
      get_random_answer: lambda do |request|
        WitAction::GetRandomAnswerService.new(request: request).call
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

  def show_main_menu
    {
      show_main_menu: lambda do |request|
        WitAction::MainMenuService.new(request: request).call
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

  def show_about_us
    {
      show_about_us: lambda do |request|
        WitAction::ShowAboutUsService.new(request: request).call
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

  def start_contest
    {
      start_contest: lambda do |request|
        WitAction::StartContestService.new(request: request).call
      end
    }
  end

  def get_contest_answer
    {
      get_contest_answer: lambda do |request|
        WitAction::GetContestAnswerService.new(request: request).call
      end
    }
  end

  def send_random_gif
    {
      send_random_gif: lambda do |request|
        WitAction::SendRandomGifService.new(request: request).call
      end
    }
  end

  def get_yes_no_answer
    {
      get_yes_no_answer: lambda do |request|
        WitAction::GetYesNoAnswerService.new(request: request).call
      end
    }
  end
end
