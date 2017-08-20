class WitAction::GetRandomNumberFactService < WitAction
  def call
    set_context_value 'fact', random_fact
    context
  end

  private

  def random_fact
    numbers_api_response.body
  end

  def numbers_api_response
    Faraday.get('http://numbersapi.com/random/trivia')
  end
end
