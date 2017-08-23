class ResponseAction::CheckSentimentService < ResponseAction
  def data
    { name: user_first_name }
  end

  def value
    sentiment
  end

  private

  def sentiment
    @sentiment ||= entities[entities.keys.first].first['value']
  end
end
