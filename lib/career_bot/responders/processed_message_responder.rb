class ProcessedMessageResponder
  def initialize(message)
    @message = message
  end

  def send_message
    Array(message_content).each do |text|
      deliver_messages(single_response(text))
    end
  end

  private

  attr_reader :message

  def message_content
    if check_entity_key
      get_data_from_entity
    else
      I18n.t('text_messages.unrecognized').sample
    end
  end

  def get_data_from_entity
    if entity.is_a?(Hash) && entity.key?(:action)
      ActionService.new(entity[:action], message_data).run
    else
      entity
    end
  end

  def single_response(text)
    text.is_a?(String) ? { text: text } : text
  end

  def entity
    I18n.t(entity_key, locale: :wit_entities)
  end

  def entity_key
    entities.keys.first
  end

  def check_entity_key
    entities.keys.any? { |key| I18n.exists?(key, :wit_entities) }
  end

  def entities
    @entities ||= message_data.entities
  end

  def message_data
    @message_data ||= MessageData.new(message)
  end

  def deliver_messages(message)
    FacebookMessenger.new.deliver(sender_id, message) if sender_id
  end

  def sender_id
    @sender_id ||= message_data.sender_id
  end
end
