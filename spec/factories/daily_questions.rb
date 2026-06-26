FactoryBot.define do
  factory :daily_question do
    sequence(:slug) { |number| "what-made-you-smile-today-#{number}" }
    sequence(:prompt) { |number| "What made you smile today? #{number}" }
    active { true }
    category { "daily_life" }
    tags { [] }
    sequence(:position)
  end
end
