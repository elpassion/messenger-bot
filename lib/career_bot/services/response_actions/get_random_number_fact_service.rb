class ResponseAction::GetRandomNumberFactService < ResponseAction
  def responses
    I18n.t('text', locale: :wit_entities, scope: :random_fact).map do |fact|
      I18n.interpolate(fact, fact: random_fact)
    end
  end

  private

  def random_fact
    numbers_api_response.body
  end

  def numbers_api_response
    Faraday.get('http://numbersapi.com/random/trivia')
  end
end
