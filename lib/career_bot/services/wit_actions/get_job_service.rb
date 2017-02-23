class WitAction::GetJobService < WitAction
  def call
    context['job_position'] = first_entity_value(request['entities'], 'position')
    context
  end
end