FactoryBot.define do
  factory :child_profile do
    association :user
    name { "Avery" }
    birthday { Date.new(2018, 5, 12) }
  end
end
