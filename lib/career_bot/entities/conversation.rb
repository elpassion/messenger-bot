class Conversation < Hanami::Entity

  attributes do
    attribute :id,          Types::Int
    attribute :session_id,  Types::String
    attribute :context,     Types::String
  end
end
