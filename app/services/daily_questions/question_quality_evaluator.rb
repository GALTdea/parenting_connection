# frozen_string_literal: true

module DailyQuestions
  class QuestionQualityEvaluator
    MAX_PROMPT_LENGTH = 160
    DEEP_PROMPT_WARNING_THRESHOLD = 0.20
    RELATIONSHIP_MIRROR_WARNING_THRESHOLD = 0.25
    LIGHT_PROMPT_MINIMUM_RATIO = 0.25
    ALL_AGE_MINIMUM_RATIO = 0.20

    HARD_FORBIDDEN_PATTERNS = {
      diagnosis: /diagnos/i,
      symptom: /symptom/i,
      behavior_problem: /behavior problem/i,
      emotional_regulation_strategy: /emotion(?:al)? regulation strategy/i,
      coping_skill: /coping skill/i,
      therapy: /\btherapy\b/i,
      therapist: /\btherapist\b/i,
      clinical: /clinical/i,
      based_on_your_pattern: /based on your pattern/i,
      noticed_you_always: /i noticed you always/i,
      app_noticed: /the app noticed/i,
      you_always: /you always/i,
      this_means: /this means/i,
      reacted: /why do you think you reacted/i,
      anger_needs: /what does your anger tell you/i,
      needs: /what are your needs/i,
      list_three: /list three/i
    }.freeze

    WARNING_PATTERNS = {
      anxiety: /\banxiety\b/i,
      trauma: /\btrauma\b/i,
      too_generic_day: /\A\s*how was your day\?\s*\z/i,
      too_generic_favorite: /\A\s*what is your favorite.+\?\s*\z/i
    }.freeze

    Result = Struct.new(:errors, :warnings, :summary, keyword_init: true) do
      def passed?
        errors.empty?
      end

      def passed
        passed?
      end
    end

    def initialize(scope: DailyQuestion.active)
      @scope = scope
    end

    def call
      Result.new(errors: errors, warnings: warnings, summary: summary)
    end

    private

    attr_reader :scope

    def records
      @records ||= Array(scope).select { |question| active?(question) }
    end

    def errors
      @errors ||= records.flat_map { |question| hard_errors_for(question) }
    end

    def warnings
      @warnings ||= records.flat_map { |question| warnings_for(question) } + coverage_warnings
    end

    def summary
      {
        active_count: records.length,
        question_families: count_by(:question_family),
        question_depths: count_by(:question_depth),
        conversation_goals: count_by(:conversation_goal),
        deep_prompt_ratio: ratio(count_by(:question_depth).fetch("deep", 0)),
        relationship_mirror_ratio: ratio(count_by(:question_family).fetch("relationship_mirror", 0)),
        all_age_ratio: ratio(records.count { |question| all_age?(question) })
      }
    end

    def hard_errors_for(question)
      [
        required_metadata_errors_for(question),
        invalid_metadata_errors_for(question),
        review_status_error_for(question),
        prompt_text_errors_for(question),
        forbidden_language_errors_for(question),
        age_bound_errors_for(question)
      ].flatten.compact
    end

    def required_metadata_errors_for(question)
      %i[question_family question_depth conversation_goal review_status].filter_map do |attribute|
        next if value_for(question, attribute).present?

        message_for(question, "#{attribute} is required for active prompts")
      end
    end

    def invalid_metadata_errors_for(question)
      {
        category: DailyQuestion::CATEGORIES,
        question_family: DailyQuestion::QUESTION_FAMILIES,
        question_depth: DailyQuestion::QUESTION_DEPTHS,
        conversation_goal: DailyQuestion::CONVERSATION_GOALS,
        review_status: DailyQuestion::REVIEW_STATUSES
      }.filter_map do |attribute, allowed_values|
        value = value_for(question, attribute)
        next if value.blank? || allowed_values.include?(value)

        message_for(question, "#{attribute} has unsupported value #{value.inspect}")
      end
    end

    def review_status_error_for(question)
      return if value_for(question, :review_status) == "approved"

      message_for(question, "active prompt is not approved for selection")
    end

    def prompt_text_errors_for(question)
      prompt = value_for(question, :prompt).to_s.strip

      [
        (message_for(question, "prompt text is blank") if prompt.blank?),
        (message_for(question, "prompt text must end with a question mark") if prompt.present? && !prompt.end_with?("?")),
        (message_for(question, "prompt text exceeds #{MAX_PROMPT_LENGTH} characters") if prompt.length > MAX_PROMPT_LENGTH)
      ].compact
    end

    def forbidden_language_errors_for(question)
      prompt = value_for(question, :prompt).to_s

      HARD_FORBIDDEN_PATTERNS.filter_map do |name, pattern|
        next unless prompt.match?(pattern)

        message_for(question, "prompt uses forbidden language: #{name}")
      end
    end

    def age_bound_errors_for(question)
      min_age = value_for(question, :min_age_years)
      max_age = value_for(question, :max_age_years)
      return if min_age.blank? || max_age.blank? || max_age >= min_age

      message_for(question, "max age must be greater than or equal to min age")
    end

    def warnings_for(question)
      warning_pattern_messages_for(question) + editorial_note_warnings_for(question)
    end

    def warning_pattern_messages_for(question)
      prompt = value_for(question, :prompt).to_s

      WARNING_PATTERNS.filter_map do |name, pattern|
        next unless prompt.match?(pattern)

        message_for(question, "prompt may need editorial review: #{name}")
      end
    end

    def editorial_note_warnings_for(question)
      return [] unless value_for(question, :question_depth) == "deep"
      return [] if value_for(question, :quality_notes).present?

      [ message_for(question, "deep prompt should include internal quality notes") ]
    end

    def coverage_warnings
      return [ "No active prompts to evaluate" ] if records.empty?

      [
        missing_value_warnings("question_family", DailyQuestion::QUESTION_FAMILIES, count_by(:question_family)),
        missing_value_warnings("question_depth", DailyQuestion::QUESTION_DEPTHS, count_by(:question_depth)),
        deep_prompt_ratio_warning,
        relationship_mirror_ratio_warning,
        light_prompt_coverage_warning,
        all_age_coverage_warning
      ].flatten.compact
    end

    def missing_value_warnings(attribute, allowed_values, counts)
      allowed_values.filter_map do |value|
        next if counts.fetch(value, 0).positive?

        "No active prompts for #{attribute}=#{value}"
      end
    end

    def deep_prompt_ratio_warning
      current_ratio = ratio(count_by(:question_depth).fetch("deep", 0))
      return if current_ratio <= DEEP_PROMPT_WARNING_THRESHOLD

      "Deep prompts exceed #{(DEEP_PROMPT_WARNING_THRESHOLD * 100).to_i}% of active prompts"
    end

    def relationship_mirror_ratio_warning
      current_ratio = ratio(count_by(:question_family).fetch("relationship_mirror", 0))
      return if current_ratio <= RELATIONSHIP_MIRROR_WARNING_THRESHOLD

      "Relationship mirror prompts exceed #{(RELATIONSHIP_MIRROR_WARNING_THRESHOLD * 100).to_i}% of active prompts"
    end

    def light_prompt_coverage_warning
      current_ratio = ratio(count_by(:question_depth).fetch("light", 0))
      return if current_ratio >= LIGHT_PROMPT_MINIMUM_RATIO

      "Light prompts are below #{(LIGHT_PROMPT_MINIMUM_RATIO * 100).to_i}% of active prompts"
    end

    def all_age_coverage_warning
      current_ratio = ratio(records.count { |question| all_age?(question) })
      return if current_ratio >= ALL_AGE_MINIMUM_RATIO

      "All-age prompts are below #{(ALL_AGE_MINIMUM_RATIO * 100).to_i}% of active prompts"
    end

    def count_by(attribute)
      records.each_with_object(Hash.new(0)) do |question, counts|
        counts[value_for(question, attribute)] += 1
      end
    end

    def ratio(count)
      return 0.0 if records.empty?

      count.to_f / records.length
    end

    def all_age?(question)
      value_for(question, :min_age_years).blank? && value_for(question, :max_age_years).blank?
    end

    def active?(question)
      return question.active? if question.respond_to?(:active?)

      value_for(question, :active)
    end

    def value_for(question, attribute)
      question.public_send(attribute) if question.respond_to?(attribute)
    end

    def message_for(question, message)
      identifier = value_for(question, :slug).presence || value_for(question, :prompt).presence || question.object_id
      "#{identifier}: #{message}"
    end
  end
end
