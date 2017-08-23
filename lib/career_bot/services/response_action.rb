class ResponseAction
  def initialize(message_data)
    @message_data = message_data
  end

  def call
    bot_deliver(text: modified_entity_text)
  end

  private

  attr_reader :message_data

  def user_first_name
    messenger_user_repository.name
  end

  def messenger_user_repository
    @messenger_user_repository ||=
      GetUserData.new(messenger_id: sender_id)
  end

  def bot_deliver(message)
    bot_interface.deliver(sender_id, message) if sender_id
  end

  def bot_interface
    @bot_interface = FacebookMessenger.new
  end

  def sender_id
    @sender_id ||= message_data.sender_id
  end

  def modified_entity_text
    I18n.t(value, merge_translation_hash)
  end

  def merge_translation_hash
    {locale: :wit_entities, scope: entity_key}.merge(data)
  end

  def entity_key
    entities.keys.first
  end

  def entities
    message_data.entities
  end
end
