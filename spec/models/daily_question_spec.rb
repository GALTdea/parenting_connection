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

    it 'requires position to be an integer when present' do
      daily_question = build(:daily_question, position: 1.5)

      expect(daily_question).not_to be_valid
      expect(daily_question.errors[:position]).to include("must be an integer")
    end
  end

  describe '.active' do
    it 'returns active questions only' do
      active_question = create(:daily_question, active: true)
      create(:daily_question, active: false)

      expect(DailyQuestion.active).to contain_exactly(active_question)
    end
  end
end
