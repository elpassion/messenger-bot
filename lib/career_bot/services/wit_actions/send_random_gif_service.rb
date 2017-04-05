class WitAction::SendRandomGifService < WitAction
  def call
    context['gif'] = first_entity_value 'gif'
    context
  end
end
