require 'rails_helper'

RSpec.describe DailyQuestion, type: :model do
  describe 'associations' do
    it 'has many memory responses' do
      expect(DailyQuestion.reflect_on_association(:memory_responses).macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'requires a prompt' do
      daily_question = build(:daily_question, prompt: nil)

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:prompt]).to include("can't be blank")
    end

    it 'requires a unique prompt' do
      create(:daily_question, prompt: "What made you smile today?")
      daily_question = build(:daily_question, prompt: "What made you smile today?")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:prompt]).to include("has already been taken")
    end

    it 'requires a unique slug' do
      create(:daily_question, slug: "what-made-you-smile-today")
      daily_question = build(:daily_question, slug: "what-made-you-smile-today")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:slug]).to include("has already been taken")
    end

    it 'requires an allowed category' do
      daily_question = build(:daily_question, category: "child_mood")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:category]).to include("is not included in the list")
    end

    it 'requires an allowed question family' do
      daily_question = build(:daily_question, question_family: "personality_profile")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:question_family]).to include("is not included in the list")
    end

    it 'requires an allowed question depth' do
      daily_question = build(:daily_question, question_depth: "intense")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:question_depth]).to include("is not included in the list")
    end

    it 'requires an allowed conversation goal' do
      daily_question = build(:daily_question, conversation_goal: "assessment")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:conversation_goal]).to include("is not included in the list")
    end

    it 'requires an allowed review status' do
      daily_question = build(:daily_question, review_status: "auto_published")

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:review_status]).to include("is not included in the list")
    end

    it 'requires tags to use the allowed list' do
      daily_question = build(:daily_question, tags: %w[quick anxious])

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:tags]).to include("include unsupported values: anxious")
    end

    it 'requires position to be an integer when present' do
      daily_question = build(:daily_question, position: 1.5)

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:position]).to include("must be an integer")
    end

    it 'requires max age to be greater than or equal to min age' do
      daily_question = build(:daily_question, min_age_years: 8, max_age_years: 4)

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:max_age_years]).to include("must be greater than or equal to min age")
    end
  end

  describe '.active' do
    it 'returns active questions only' do
      active_question = create(:daily_question, active: true)
      create(:daily_question, active: false)

      expect(DailyQuestion.active).to contain_exactly(active_question)
    end
  end

  describe '.age_eligible' do
    it 'returns questions with matching broad age guidance' do
      all_age_question = create(:daily_question, min_age_years: nil, max_age_years: nil)
      older_question = create(:daily_question, min_age_years: 10, max_age_years: nil)
      younger_question = create(:daily_question, min_age_years: nil, max_age_years: 6)

      expect(DailyQuestion.age_eligible(8)).to contain_exactly(all_age_question)
      expect(DailyQuestion.age_eligible(11)).to include(older_question)
      expect(DailyQuestion.age_eligible(5)).to include(younger_question)
    end
  end
end
