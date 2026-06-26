# frozen_string_literal: true

class PersonalizedFollowUpEligibility
  LOOKBACK_WINDOW_DAYS = 90
  MINIMUM_TEXT_MEMORY_COUNT = 3
  FREQUENCY_WINDOW_DAYS = 7
  PERSONALIZED_SOURCE_TYPES = %w[
    adapted_curated
    personalized_follow_up
  ].freeze

  Result = Struct.new(:eligible, :reason, :eligible_memory_count, keyword_init: true) do
    def eligible?
      eligible
    end
  end

  def initialize(child_profile:, date: Date.current)
    @child_profile = child_profile
    @date = date
  end

  def result
    return ineligible(:recent_personalized_follow_up) if recent_personalized_follow_up?
    return ineligible(:insufficient_text_memories) if eligible_memory_count < MINIMUM_TEXT_MEMORY_COUNT

    Result.new(eligible: true, reason: :eligible, eligible_memory_count: eligible_memory_count)
  end

  private

  attr_reader :child_profile, :date

  def ineligible(reason)
    Result.new(eligible: false, reason: reason, eligible_memory_count: eligible_memory_count)
  end

  def eligible_memory_count
    @eligible_memory_count ||= eligible_text_memories.count
  end

  def eligible_text_memories
    child_profile.memory_responses
      .where(answered_on: lookback_range)
      .where.not(response_text: [ nil, "" ])
  end

  def lookback_range
    (date - LOOKBACK_WINDOW_DAYS)..date
  end

  def recent_personalized_follow_up?
    child_profile.daily_question_selections
      .where(source_type: PERSONALIZED_SOURCE_TYPES)
      .where(selected_on: (date - FREQUENCY_WINDOW_DAYS)...date)
      .exists?
  end
end
