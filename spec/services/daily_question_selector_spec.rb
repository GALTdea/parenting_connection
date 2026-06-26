require 'rails_helper'

RSpec.describe DailyQuestionSelector do
  describe '#question' do
    it 'returns the existing selection for the child and date' do
      child_profile = create(:child_profile)
      selected_question = create(:daily_question, prompt: "What felt cozy today?")
      create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: selected_question,
        selected_on: Date.new(2026, 6, 26))
      create(:daily_question, prompt: "What made you smile today?")

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to eq(selected_question)
    end

    it 'creates one stable selection for the child and date' do
      child_profile = create(:child_profile)
      create(:daily_question, prompt: "What made you smile today?")

      first_question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      second_question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(second_question).to eq(first_question)
      expect(child_profile.daily_question_selections.where(selected_on: Date.new(2026, 6, 26)).count).to eq(1)
    end

    it 'does not newly select inactive questions' do
      child_profile = create(:child_profile)
      create(:daily_question, active: false, prompt: "What felt quiet today?")

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to be_nil
    end

    it 'keeps a same-day selection stable when the question is later inactive' do
      child_profile = create(:child_profile)
      selected_question = create(:daily_question, prompt: "What made you smile today?")

      first_question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      selected_question.update!(active: false)
      second_question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(first_question).to eq(selected_question)
      expect(second_question).to eq(selected_question)
    end

    it 'avoids recently selected questions when alternatives exist' do
      child_profile = create(:child_profile)
      recent_question = create(:daily_question, prompt: "What made you smile today?", position: 1)
      alternative_question = create(:daily_question, prompt: "What felt cozy today?", position: 2)
      create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: recent_question,
        selected_on: Date.new(2026, 6, 25))

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to eq(alternative_question)
    end

    it 'relaxes recent-repeat avoidance when the eligible library is too small' do
      child_profile = create(:child_profile)
      recent_question = create(:daily_question, prompt: "What made you smile today?", position: 1)
      create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: recent_question,
        selected_on: Date.new(2026, 6, 25))

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to eq(recent_question)
    end

    it 'uses all-age fallback when age-specific prompts do not match' do
      child_profile = create(:child_profile, birthday: Date.new(2018, 5, 12))
      all_age_question = create(:daily_question, prompt: "What made you smile today?", position: 1)
      create(:daily_question, prompt: "What did you do as a teenager today?", min_age_years: 13, position: 2)

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to eq(all_age_question)
    end
  end
end
