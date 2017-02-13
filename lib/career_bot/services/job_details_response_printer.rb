class JobDetailsResponsePrinter
  def print_response
    postback.reply(text: response[:text])
    response[:data].first(5).each { |element| postback.reply(text: "- #{element}") }
    postback.reply(text: apply_for_job_text)
  end

  private

  attr_reader :postback, :response

  def initialize(postback, response)
    @postback = postback
    @response = response
  end

  def apply_for_job_text
    I18n.t('text_messages.apply_for_job',
           job_url: response[:job_url],
           position: response[:job_title],
           application_url: response[:application_url])
  end
end
