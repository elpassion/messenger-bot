class Conversation < Hanami::Entity

  attributes do
    attribute :id,                  Types::Int
    attribute :session_uid,         Types::String
    attribute :messenger_id,        Types::String
    attribute :context,             Types::Hash
    attribute :job_codes,           Types::String
    attribute :apply,               Types::Bool
    attribute :apply_job_shortcode, Types::String
    attribute :notifications,       Types::Bool
    attribute :question_index,      Types::Int
    attribute :text_answers,        Types::Hash
    attribute :complex_answers,     Types::Hash
  end
end
