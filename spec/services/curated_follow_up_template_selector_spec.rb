require 'rails_helper'

RSpec.describe CuratedFollowUpTemplateSelector do
  describe '#result' do
    let(:date) { Date.new(2026, 6, 26) }
    let(:child_profile) { create(:child_profile) }

    it 'returns a curated template follow-up for an eligible child' do
      source_memory = create_text_memory(
        category: "imagination",
        answered_on: date - 1.day
      )
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result.daily_question).to eq(source_memory.daily_question)
      expect(result.source_memory_response).to eq(source_memory)
      expect(result.presented_prompt).to eq(
        "Last time we talked about something you imagined. What would you add to that idea today?"
      )
    end

    it 'returns nil when the child is not eligible' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'uses memories from the current child only' do
      other_child = create(:child_profile)
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create(:memory_response,
        child_profile: other_child,
        daily_question: create(:daily_question, category: "imagination"),
        response_text: "Other child memory",
        answered_on: date - 1.day)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'ignores memories outside the lookback window' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 91.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'ignores voice-only memories' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_voice_only_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'requires the source memory category to have a safe template' do
      hide_templates_for("imagination") do
        create_text_memory(category: "imagination", answered_on: date - 1.day)
        create_text_memory(category: "imagination", answered_on: date - 2.days)
        create_text_memory(category: "imagination", answered_on: date - 3.days)

        result = described_class.new(child_profile: child_profile, date: date).result

        expect(result).to be_nil
      end
    end

    it 'respects the personalized follow-up frequency limit' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)
      create(:daily_question_selection,
        child_profile: child_profile,
        selected_on: date - 1.day,
        source_type: "personalized_follow_up")

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'does not reuse a source memory response' do
      used_source = create_text_memory(answered_on: date - 1.day)
      next_source = create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)
      create(:daily_question_selection,
        child_profile: child_profile,
        selected_on: date - 10.days,
        source_memory_response: used_source)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result.source_memory_response).to eq(next_source)
    end

    it 'returns nil when no safe unused source remains' do
      used_sources = [
        create_text_memory(answered_on: date - 1.day),
        create_text_memory(answered_on: date - 2.days),
        create_text_memory(answered_on: date - 3.days)
      ]
      used_sources.each_with_index do |source_memory, index|
        create(:daily_question_selection,
          child_profile: child_profile,
          selected_on: date - (index + 10).days,
          source_memory_response: source_memory)
      end

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_nil
    end

    it 'does not require any AI provider configuration' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_present
    end

    def create_text_memory(category: "daily_life", answered_on:)
      create(:memory_response,
        child_profile: child_profile,
        daily_question: create(:daily_question, category: category),
        response_text: "A saved text memory",
        answered_on: answered_on)
    end

    def create_voice_only_memory(answered_on:)
      memory_response = build(:memory_response,
        child_profile: child_profile,
        daily_question: create(:daily_question),
        response_text: nil,
        answered_on: answered_on)
      memory_response.voice_recording.attach(
        io: Rails.root.join("spec/fixtures/files/sample_audio.webm").open,
        filename: "sample_audio.webm",
        content_type: "audio/webm"
      )
      memory_response.save!
      memory_response
    end

    def hide_templates_for(category)
      templates = described_class::TEMPLATES_BY_CATEGORY.deep_dup
      templates.delete(category)

      stub_const("#{described_class}::TEMPLATES_BY_CATEGORY", templates.freeze)
      yield
    end
  end
end
