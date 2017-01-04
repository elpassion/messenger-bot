class UrlButton
  def to_hash
    {
      type: 'web_url',
      url: url,
      title: title
    }
  end

  private

  attr_reader :url, :title

  def initialize (url, title)
    @url = url
    @title = title
  end
end