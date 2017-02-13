class GenericTemplateElement
  IMG_URLS = %w[70 26-1 27-1 65 28-1 66].freeze

  def to_hash
    {
      title: job['title'],
      image_url: "http://www.elpassion.com/wp-content/uploads/2015/03/Bez-nazwy-#{IMG_URLS.sample}.jpg",
      subtitle: job['full_title'],
      default_action: default_action,
      buttons: buttons
    }
  end

  private

  attr_reader :job

  def initialize(job)
    @job = job
  end

  def buttons
    [
      UrlButton.new(job['application_url'], 'Apply for offer').to_hash,
      PostbackButton.new('Show requirements', "requirements|#{job_shortcode}").to_hash,
      PostbackButton.new('Show benefits', "benefits|#{job_shortcode}").to_hash
    ]
  end

  def default_action
    {
      type: 'web_url',
      url: job['url']
    }
  end

  def job_shortcode
    job['shortcode']
  end
end
