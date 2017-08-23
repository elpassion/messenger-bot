class WitAction::CheckSentimentService < WitAction
  def call
    set_context_value sentiment, true
    set_context_value 'name', user_first_name
    context
  end

  private

  def sentiment
    context['sentiment'] = first_entity_value 'sentiment'
  end
end
