require 'rails_helper'

RSpec.describe 'prompt library seeds' do
  it 'provide the Stage 6 release-ready prompt library' do
    load Rails.root.join("db/seeds.rb")

    active_questions = DailyQuestion.active

    expect(active_questions.count).to be >= 60
    expect(active_questions.where(min_age_years: nil, max_age_years: nil).count).to be >= 10

    DailyQuestion::CATEGORIES.each do |category|
      expect(active_questions.where(category: category).count).to be >= 4
    end

    DailyQuestion::QUESTION_FAMILIES.each do |question_family|
      expect(active_questions.where(question_family: question_family).count).to be >= 4
    end

    DailyQuestion::QUESTION_DEPTHS.each do |question_depth|
      expect(active_questions.where(question_depth: question_depth).count).to be >= 4
    end

    expect(active_questions.where(question_family: DailyQuestion::QUESTION_FAMILIES).count).to eq(active_questions.count)
    expect(active_questions.where(question_depth: DailyQuestion::QUESTION_DEPTHS).count).to eq(active_questions.count)
    expect(active_questions.where(conversation_goal: DailyQuestion::CONVERSATION_GOALS).count).to eq(active_questions.count)
    expect(active_questions.where(review_status: "approved").count).to eq(active_questions.count)

    expect(active_questions.where(question_depth: "deep").count).to be < (active_questions.count * 0.15)
    expect(active_questions.where.not(quality_notes: [ nil, "" ]).count).to be >= 5
    expect(active_questions.age_eligible(5).count).to be >= 10
    expect(active_questions.age_eligible(8).count).to be >= 10
    expect(active_questions.age_eligible(11).count).to be >= 10
    expect(active_questions.age_eligible(14).count).to be >= 10
  end

  it 'keeps active prompts out of forbidden clinical and surveillance language' do
    load Rails.root.join("db/seeds.rb")

    forbidden_patterns = [
      /emotion regulation/i,
      /deepest fear/i,
      /list three/i,
      /i noticed/i,
      /based on/i,
      /diagnos/i,
      /clinical/i,
      /assessment/i,
      /score/i,
      /what values are guiding/i,
      /why do you think you reacted/i
    ]

    prompts = DailyQuestion.active.pluck(:prompt)

    forbidden_patterns.each do |pattern|
      expect(prompts.grep(pattern)).to be_empty
    end
  end

  it 'documents golden questions with internal quality notes' do
    load Rails.root.join("db/seeds.rb")

    golden_slugs = %w[
      if-your-mind-had-a-secret-room
      what-should-i-remember-about-you-at-this-age
      when-do-you-feel-like-i-understand-you
      what-memory-with-me-should-we-never-forget
      how-is-it-to-have-a-father-like-me
    ]

    golden_questions = DailyQuestion.where(slug: golden_slugs)

    expect(golden_questions.count).to eq(golden_slugs.length)
    expect(golden_questions).to all(have_attributes(review_status: "approved"))
    expect(golden_questions.pluck(:quality_notes)).to all(be_present)
  end

  it 'passes the deterministic question quality evaluator' do
    load Rails.root.join("db/seeds.rb")

    result = DailyQuestions::QuestionQualityEvaluator.new(scope: DailyQuestion.active).call

    expect(result).to be_passed
    expect(result.errors).to be_empty
    expect(result.warnings).to be_empty
  end

  it 'upserts prompts by slug without duplicating records' do
    load Rails.root.join("db/seeds.rb")
    count_after_first_load = DailyQuestion.count

    load Rails.root.join("db/seeds.rb")

    expect(DailyQuestion.count).to eq(count_after_first_load)
  end
end
