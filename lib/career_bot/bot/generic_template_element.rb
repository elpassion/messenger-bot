class GenericTemplateElement
  BUTTONS = [
    { title: 'View offer on page', url: 'url' },
    { title: 'Apply for offer', url: 'application_url' }
  ].freeze

  def to_hash
    {
      title: job['title'],
      image_url: 'https://workablehr.s3.amazonaws.com/uploads/account/logo/13617/large_logo_elpasison_v1.1.png',
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
      UrlButton.new(job['url'], 'View offer on page').to_hash,
      UrlButton.new(job['application_url'], 'Apply for offer').to_hash,
      PostbackButton.new('Show offer requirements', payload).to_hash
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

  def payload
    "JOB_DETAILS|#{job_shortcode}"
  end
end
