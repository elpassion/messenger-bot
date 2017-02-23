class WitAction
  def initialize(request:)
    @request = request
  end

  private

  attr_reader :request

  def session_uid
    request['session_id']
  end

  def context
    request['context']
  end

  def first_entity_value(entities, entity)
    entities[entity][0]['value'] if entities.has_key? entity
  end

  def update_context(context, session_uid)
    repository.update(conversation(session_uid).id, context: context )
  end

  def conversation(session_uid)
    @conversation ||= repository.find_by_session_uid(session_uid)
  end

  def repository
    @repository ||= ConversationRepository.new
  end
end