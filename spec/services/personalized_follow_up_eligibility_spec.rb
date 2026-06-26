require 'rails_helper'

RSpec.describe PersonalizedFollowUpEligibility do
  describe '#result' do
    let(:date) { Date.new(2026, 6, 26) }
    let(:child_profile) { create(:child_profile) }

    it 'is not eligible when the child has fewer than three text memories' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).not_to be_eligible
      expect(result.reason).to eq(:insufficient_text_memories)
      expect(result.eligible_memory_count).to eq(2)
    end

    it 'can be eligible when the child has at least three text memories in the lookback window' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_eligible
      expect(result.reason).to eq(:eligible)
      expect(result.eligible_memory_count).to eq(3)
    end

    it 'does not count memories from another child' do
      other_child = create(:child_profile)
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create(:memory_response, child_profile: other_child, response_text: "Other child memory", answered_on: date - 1.day)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).not_to be_eligible
      expect(result.eligible_memory_count).to eq(2)
    end

    it 'does not count voice-only memories' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_voice_only_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).not_to be_eligible
      expect(result.eligible_memory_count).to eq(2)
    end

    it 'does not count text memories outside the lookback window' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 91.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).not_to be_eligible
      expect(result.eligible_memory_count).to eq(2)
    end

    it 'is not eligible when a personalized source type was recently selected' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)
      create(:daily_question_selection,
        child_profile: child_profile,
        selected_on: date - 1.day,
        source_type: "personalized_follow_up")

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).not_to be_eligible
      expect(result.reason).to eq(:recent_personalized_follow_up)
    end

    it 'does not require any AI provider configuration' do
      create_text_memory(answered_on: date - 1.day)
      create_text_memory(answered_on: date - 2.days)
      create_text_memory(answered_on: date - 3.days)

      result = described_class.new(child_profile: child_profile, date: date).result

      expect(result).to be_eligible
    end

    def create_text_memory(answered_on:)
      create(:memory_response,
        child_profile: child_profile,
        response_text: "A saved text memory",
        answered_on: answered_on)
    end

    def create_voice_only_memory(answered_on:)
      memory_response = build(:memory_response,
        child_profile: child_profile,
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
  end
end
