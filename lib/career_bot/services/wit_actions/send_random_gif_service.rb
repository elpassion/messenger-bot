class WitAction::SendRandomGifService < WitAction
  def call
    context['gif'] = true
    context
  end
end
