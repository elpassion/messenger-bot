class ButtonTemplate
  def to_hash(buttons)
    {
      type: 'template',
      payload: {
        template_type: 'button',
        text: text,
        buttons: buttons
      }
    }
  end

  private

  attr_reader :text

  def initialize(text)
    @text = text
  end
end