FactoryBot.define do
  factory :daily_question_selection do
    association :child_profile
    association :daily_question
    selected_on { Date.current }
  end
end
