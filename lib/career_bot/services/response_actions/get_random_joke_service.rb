class ResponseAction::GetRandomJokeService < ResponseAction
  def responses
    I18n.t('text', locale: :wit_entities, scope: :joke).map do |joke_line|
      I18n.interpolate(joke_line, joke: random_joke)
    end
  end

  private

  def random_joke
    I18n.t('body', locale: :jokes).sample
  end
end
