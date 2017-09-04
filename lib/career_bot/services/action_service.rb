class ActionService
  def initialize(action, message_data)
    @action = action
    @message_data = message_data
  end

  def run
    Array(generate_class.new(message_data).responses)
  end

  private

  attr_reader :action, :message_data

  def generate_class
    "ResponseAction::#{generate_class_name}Service".constantize
  end

  def generate_class_name
    action.split('_').map(&:capitalize).join
  end
end
