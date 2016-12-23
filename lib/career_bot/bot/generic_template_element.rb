class GenericTemplateElement
  BUTTONS = [
    { title: 'View offer', url: 'url' },
    { title: 'Apply for offer', url: 'application_url' }
  ].freeze

  def element
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
    @buttons ||= BUTTONS.reduce([]) do |result, button|
      result << button(button)
    end
  end

  def button(button)
    @button_hash ||= {
      type: 'web_url',
      url: job[button[:url]],
      title: button[:title]
    }
  end

  def default_action
    {
      type: 'web_url',
      url: job['url']
    }
  end
end
