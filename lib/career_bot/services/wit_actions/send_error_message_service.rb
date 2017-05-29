class WitAction::SendErrorMessageService < WitAction
  def call
    context['error'] = first_entity_value 'error'
    context
  end
end
