class GenericTemplateElement
  def to_hash
    {
      title: job['title'],
      image_url: "https://s3.eu-west-2.amazonaws.com/elpassion/#{rand(1..7)}.jpg",
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
