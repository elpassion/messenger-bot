class WitAction::CheckSentimentService < WitAction
  def call
    set_context_value sentiment, true
    context
  end

  private

  def sentiment
    context['sentiment'] = first_entity_value 'sentiment'
  end
end
