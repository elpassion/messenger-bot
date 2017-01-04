class PostbackButton
  def to_hash
    {
      type: 'postback',
      title: title,
      payload: payload
    }
  end

  private

  attr_reader :title, :payload

  def initialize(title, payload)
    @title = title
    @payload = payload
  end
end