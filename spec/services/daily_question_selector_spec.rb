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

    it 'stores curated source metadata and the presented prompt for a new selection' do
      child_profile = create(:child_profile)
      create(:daily_question, prompt: "What made you smile today?")

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.new(2026, 6, 26))

      expect(selection.daily_question).to eq(question)
      expect(selection.source_type).to eq("curated")
      expect(selection.presented_prompt).to eq("What made you smile today?")
    end

    it 'creates a template follow-up selection for an eligible child' do
      child_profile = create(:child_profile)
      source_memory = create_memory_response(
        child_profile: child_profile,
        daily_question: create(:daily_question, category: "imagination"),
        answered_on: Date.new(2026, 6, 25)
      )
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 24))
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 23))
      create(:daily_question, prompt: "What made you smile today?", position: 99)

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.new(2026, 6, 26))

      expect(question).to eq(source_memory.daily_question)
      expect(selection.source_type).to eq("personalized_follow_up")
      expect(selection.source_memory_response).to eq(source_memory)
      expect(selection.presented_prompt).to eq(
        "Last time we talked about something you imagined. What would you add to that idea today?"
      )
    end

    it 'falls back to a curated prompt when a child is not eligible for a template follow-up' do
      child_profile = create(:child_profile)
      create(:daily_question, prompt: "What made you smile today?")
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 25))
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 24))

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.new(2026, 6, 26))

      expect(selection.source_type).to eq("curated")
      expect(selection.source_memory_response).to be_nil
      expect(selection.daily_question).to eq(question)
      expect(selection.presented_prompt).to eq(question.prompt)
    end

    it 'does not replace an existing same-day selection with a template follow-up' do
      child_profile = create(:child_profile)
      selected_question = create(:daily_question, prompt: "What felt cozy today?")
      existing_selection = create(:daily_question_selection,
        child_profile: child_profile,
        daily_question: selected_question,
        selected_on: Date.new(2026, 6, 26))
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 25))
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 24))
      create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 23))

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question

      expect(question).to eq(selected_question)
      expect(child_profile.daily_question_selections.where(selected_on: Date.new(2026, 6, 26))).to contain_exactly(existing_selection)
      expect(existing_selection.reload.source_type).to eq("curated")
    end

    it 'falls back to curated prompts when no safe unused source remains' do
      child_profile = create(:child_profile)
      used_sources = [
        create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 25)),
        create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 24)),
        create_memory_response(child_profile: child_profile, answered_on: Date.new(2026, 6, 23))
      ]
      used_sources.each_with_index do |source_memory, index|
        create(:daily_question_selection,
          child_profile: child_profile,
          selected_on: Date.new(2026, 6, 10 + index),
          source_memory_response: source_memory)
      end
      create(:daily_question, prompt: "What made you smile today?", position: 1)

      question = described_class.new(child_profile: child_profile, date: Date.new(2026, 6, 26)).question
      selection = child_profile.daily_question_selections.find_by!(selected_on: Date.new(2026, 6, 26))

      expect(selection.source_type).to eq("curated")
      expect(selection.source_memory_response).to be_nil
      expect(selection.daily_question).to eq(question)
      expect(selection.presented_prompt).to eq(question.prompt)
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

    def create_memory_response(child_profile:, daily_question: create(:daily_question), answered_on:)
      create(:memory_response,
        child_profile: child_profile,
        daily_question: daily_question,
        response_text: "A saved text memory",
        answered_on: answered_on)
    end
  end
end
