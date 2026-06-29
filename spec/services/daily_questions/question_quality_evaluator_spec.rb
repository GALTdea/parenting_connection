require 'rails_helper'

RSpec.describe DailyQuestions::QuestionQualityEvaluator do
  describe '#call' do
    it 'passes the current curated seed library' do
      load Rails.root.join("db/seeds.rb")

      result = described_class.new(scope: DailyQuestion.active).call

      expect(result).to be_passed
      expect(result.errors).to be_empty
      expect(result.warnings).to be_empty
      expect(result.summary[:active_count]).to be >= 60
    end

    it 'fails when an active prompt is missing required metadata' do
      question = build_question(question_family: nil)

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/question_family is required/))
    end

    it 'fails when forbidden clinical or surveillance language appears' do
      question = build_question(prompt: "What emotion regulation strategy did you use today?")

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/forbidden language: emotional_regulation_strategy/))
    end

    it 'warns when ambiguous sensitive language appears' do
      question = build_question(prompt: "What helps when anxiety feels loud?")

      result = described_class.new(scope: [ question ]).call

      expect(result).to be_passed
      expect(result.warnings).to include(a_string_matching(/editorial review: anxiety/))
    end

    it 'warns when deep prompts exceed the safe threshold' do
      questions = [
        build_question(slug: "deep-1", question_depth: "deep", quality_notes: "Reviewed deep prompt."),
        build_question(slug: "deep-2", question_depth: "deep", quality_notes: "Reviewed deep prompt."),
        build_question(slug: "deep-3", question_depth: "deep", quality_notes: "Reviewed deep prompt."),
        build_question(slug: "light-1", question_depth: "light")
      ]

      result = described_class.new(scope: questions).call

      expect(result.warnings).to include(a_string_matching(/Deep prompts exceed/))
    end

    it 'warns when a question family has no coverage' do
      questions = DailyQuestion::QUESTION_FAMILIES.excluding("silly_to_deep").map.with_index do |family, index|
        build_question(slug: "family-#{index}", question_family: family)
      end

      result = described_class.new(scope: questions).call

      expect(result.warnings).to include("No active prompts for question_family=silly_to_deep")
    end

    it 'flags active unapproved prompts as hard errors' do
      question = build_question(review_status: "draft")

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/active prompt is not approved for selection/))
    end

    it 'flags blank prompt text' do
      question = build_question(prompt: "")

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/prompt text is blank/))
    end

    it 'flags overly long prompt text' do
      question = build_question(prompt: "#{'What would you tell me about today ' * 6}?")

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/prompt text exceeds/))
    end

    it 'flags prompt text that is not question-like' do
      question = build_question(prompt: "Tell me about today.")

      result = described_class.new(scope: [ question ]).call

      expect(result).not_to be_passed
      expect(result.errors).to include(a_string_matching(/must end with a question mark/))
    end

    it 'does not mutate the evaluated questions' do
      question = create(:daily_question, prompt: "What made you smile today?")

      expect {
        described_class.new(scope: DailyQuestion.where(id: question.id)).call
      }.not_to change { question.reload.attributes }
    end
  end

  def build_question(attributes = {})
    build_stubbed(:daily_question, {
      active: true,
      slug: "what-made-you-smile",
      prompt: "What made you smile today?",
      category: "daily_life",
      question_family: "inner_world",
      question_depth: "light",
      conversation_goal: "storytelling",
      review_status: "approved"
    }.merge(attributes))
  end
end
