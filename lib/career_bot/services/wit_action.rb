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
    entity_value = entities[entity][0]['value'] if entities.key? entity
    transliterate(entity_value)
  end

  def transliterate(entity_val)
    entity_val.is_a?(String) ? I18n.transliterate(entity_val) : entity_val
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

  def set_context_true(*keys)
    keys.each { |key| set_context_value(key, true) }
  end

  def remove_from_context(*keys)
    keys.each { |key| context.delete(key) }
  end

  def set_context_value(key, value)
    context[key] = value
  end

  def messenger_id
    conversation.messenger_id if conversation
  end

  def user_first_name
    GetUserData.new(messenger_id: messenger_id).first_name
  end
end
