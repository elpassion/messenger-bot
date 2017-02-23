FactoryGirl.define do
  factory :conversation do
    session_uid '1234567890'
    sequence(:messenger_id) { |n| n }

    initialize_with { new(attributes) }
  end
end
