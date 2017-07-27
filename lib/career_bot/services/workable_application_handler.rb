class WorkableApplicationHandler < BotResponder
  def post_candidate_answers
    response = post_application_form_request
    parsed_response = JSON.parse(response.body)

    if parsed_response['error']
      on_post_failure(parsed_response['error'])
    else
      bot_deliver(text: I18n.t('apply_process.form_submitted'))
    end
  end

  def deliver_answers_summary
    bot_deliver(text: I18n.t('apply_process.responses_saved'))
    deliver_formatted_answers
    bot_deliver(text: I18n.t('apply_process.are_information_correct'),
                quick_replies: I18n.t('boolean_postback', locale: :responses))
  end

  private

  attr_reader :conversation

  def initialize(conversation, **options)
    @conversation = conversation
    super(**options)
  end

  def post_application_form_request
    conn.post do |req|
      req.url request_url
      req.headers['Authorization'] = "Bearer #{ ENV['WORKABLE_API_KEY'] }"
      req.headers['Content-Type'] = 'application/json'
      req.body = request_body
    end
  end

  def request_body
    "{ \"sourced\": false, \"candidate\": { #{ merged_text_answers }, "\
    "\"answers\": [ #{ merged_complex_answers } ] } }"
  end

  def merged_text_answers
    conversation.text_answers.map do |key, value|
      "\"#{ text_replies_keys[key] }\": \"#{ value }\""
    end.join(', ')
  end

  def deliver_formatted_answers
    conversation.text_answers.sort.map do |key, value|
      formatted_key = key.to_s.split('_').join(' ').capitalize
      bot_deliver(text: "#{ formatted_key }: #{ value }")
    end
    conversation.complex_answers.map do |key, value|
      bot_deliver(text: "#{ key } #{ value[:reply] }")
    end
  end

  def text_replies_keys
    {
      first_name: 'firstname',
      last_name: 'lastname',
      avatar: 'image_url',
      email: 'email',
      phone: 'phone',
      summary: 'summary',
      resume: 'resume_url'
    }
  end

  def merged_complex_answers
    conversation.complex_answers.map { |key, value| value[:to_send] }.join(', ')
  end

  def on_post_failure(error)
    bot_deliver(text: I18n.t('apply_process.form_error'))
    bot_deliver(text: error)
    bot_deliver(text: I18n.t('apply_process.try_again'))
  end

  def conn
    @conn ||= Faraday.new(url: 'https://www.workable.com')
  end

  def request_url
    "/spi/v3/accounts/elpassion/jobs/#{conversation.apply_job_shortcode}/candidates"
  end
end
