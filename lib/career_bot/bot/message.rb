class Message
  def initialize(message)
    @message = message
  end

  def send_message
    if entities.keys.any? { |key| I18n.exists?(key, :wit_entities) }
      Array(message_content).each do |text|
        deliver_messages(single_response(text))
      end
    else
      deliver_messages(text: "I don't understand")
    end
  end

  def message_content
    if entity.is_a?(Hash) && entity.has_key?(:action)
      ActionResponseService.new(entity[:action], message_data).run
    else
      entity
    end
  end

  private

  attr_reader :message

  def single_response(text)
    text.is_a?(String) ? { text: text } : text
  end

  def session_uid
    conversation.session_uid
  end

  def sender_id
    @sender_id ||= message_data.sender_id
  end

  def modified_entity_text
    I18n.t(@value, merge_translation_hash)
  end

  def merge_translation_hash
    { locale: :wit_entities, scope: entity_key }.merge(@data)
  end

  def entity
    I18n.t(entity_key, locale: :wit_entities)
  end

  def entity_key
    entities.keys.first
  end

  def entities
    @entities ||= message_data.entities
  end

  def message_data
    @message_data ||= MessageData.new(message)
  end

  def deliver_messages(message)
    bot_interface.deliver(sender_id, message) if sender_id
  end

  def bot_interface
    @bot_interface = FacebookMessenger.new
  end
end
