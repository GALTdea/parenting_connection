require 'rails_helper'

RSpec.describe 'prompt library seeds' do
  it 'provide the Stage 6 release-ready prompt library' do
    load Rails.root.join("db/seeds.rb")

    active_questions = DailyQuestion.active

    expect(active_questions.count).to be >= 40
    expect(active_questions.where(min_age_years: nil, max_age_years: nil).count).to be >= 10

    DailyQuestion::CATEGORIES.each do |category|
      expect(active_questions.where(category: category).count).to be >= 4
    end
  end

  it 'upserts prompts by slug without duplicating records' do
    load Rails.root.join("db/seeds.rb")
    count_after_first_load = DailyQuestion.count

    load Rails.root.join("db/seeds.rb")

    expect(DailyQuestion.count).to eq(count_after_first_load)
  end
end
