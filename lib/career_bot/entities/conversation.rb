class Conversation < Hanami::Entity

  attributes do
    attribute :id,              Types::Int
    attribute :session_uid,     Types::String
    attribute :messenger_id,    Types::String
    attribute :context,         Types::Hash
    attribute :job_codes,       Types::String
    attribute :apply,           Types::Bool
    attribute :candidate_info,  Types::Hash
  end
end
