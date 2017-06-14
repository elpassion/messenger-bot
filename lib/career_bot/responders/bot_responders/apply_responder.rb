class ApplyResponder < BotResponder
  def initialize(conversation_id:, **options)
    @conversation_id = conversation_id
    super(**options)
  end

  def response
    bot_deliver(text: 'Section in progress')
    bot_deliver(text: 'Questions to be asked:')
    all_job_questions.each do |question|
      text = question['key'] || 'empty'
      bot_deliver(text: text)
    end
    repository.update(conversation_id, apply: false)
  end

  private

  attr_reader :conversation_id

  def all_job_questions
    base_questions_hash + form_fields
  end

  def base_questions_hash
    [
      { 'key' => 'firstname', 'type' => 'string', 'required' => true } ,
      { 'key' => 'lastname', 'type' => 'string', 'required' => true } ,
      { 'key' => 'email', 'type' => 'string', 'required' => true }
    ]
  end

  def form_fields
    job.form_fields
  end

  def job
    @job ||= JobParser.new(job_code)
  end

  def job_code
    conversation.candidate_info[:job][:shortcode]
  end

  def conversation
    repository.find(conversation_id)
  end
end