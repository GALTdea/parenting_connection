FactoryBot.define do
  factory :daily_question do
    sequence(:prompt) { |number| "What made you smile today? #{number}" }
    active { true }
    sequence(:position)
  end
end
