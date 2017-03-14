class WitAction::GetDetailsService < WitAction
  def call
    set_context_value 'details', details
    context
  end

  private

  def details
    first_entity_value 'offer_details'
  end
end
