class WitAction::GetRandomJokeService < WitAction
  def call
    set_context_value 'joke', random_joke
    context
  end

  private

  def random_joke
    I18n.t('body', locale: :jokes).sample
  end
end
