FactoryBot.define do
  factory :memory_response do
    association :child_profile
    association :daily_question
    response_text { "I liked building a tower after breakfast." }
    answered_on { Date.current }
  end
end
