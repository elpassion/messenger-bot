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
    @context ||= request['context']
  end

  def first_entity_value(entity)
    entities[entity][0]['value'] if entities.key? entity
  end

  def entities
    @entities ||= request['entities']
  end

  def update_context(context)
    repository.update(conversation.id, context: context)
  end

  def conversation
    @conversation ||= repository.find_by_session_uid(session_uid)
  end

  def repository
    @repository ||= ConversationRepository.new
  end

  def set_context_nil(*keys)
    keys.each { |key| set_context_value(key, nil) }
  end

  def set_context_true(*keys)
    keys.each { |key| set_context_value(key, true) }
  end

  def set_context_value(key, value)
    context[key] = value
  end

  def messenger_id
    conversation.messenger_id
  end

  def messenger_user_repository
    @messenger_user_repository ||= MessengerUserRepository.new(messenger_id: messenger_id)
  end

  def user_first_name
    messenger_user_repository.name
  end
end
