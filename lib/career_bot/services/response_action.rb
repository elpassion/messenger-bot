class ResponseAction
  def initialize(message_data)
    @message_data = message_data
  end

  def responses
    I18n.t(value, merge_translation_hash)
  end

  private

  attr_reader :message_data

  def single_response(text)
    text.is_a?(String) ? { text: text } : text
  end

  def merge_translation_hash
    { locale: :wit_entities, scope: entity_key }.merge(data)
  end

  def user_first_name
    messenger_user_repository.first_name
  end

  def messenger_user_repository
    GetUserData.new(messenger_id: sender_id)
  end

  def sender_id
    @sender_id ||= message_data.sender_id
  end

  def entity_key
    entities.keys.first
  end

  def entities
    message_data.entities
  end
end
