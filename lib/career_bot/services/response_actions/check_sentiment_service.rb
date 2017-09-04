class ResponseAction::CheckSentimentService < ResponseAction
  private

  def data
    { name: user_first_name }
  end

  def value
    sentiment
  end

  def sentiment
    @sentiment ||= entities[entities.keys.first].first['value']
  end
end
