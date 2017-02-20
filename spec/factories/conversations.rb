FactoryGirl.define do
  factory :conversation do
    session_id '1234567890'
    context 'some context'

    initialize_with { new(attributes) }
  end
end
