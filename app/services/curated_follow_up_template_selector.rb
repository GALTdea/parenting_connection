# frozen_string_literal: true

class CuratedFollowUpTemplateSelector
  TEMPLATES_BY_CATEGORY = {
    "daily_life" => [
      "Thinking back to one of your recent days, what small moment do you still remember?"
    ],
    "feelings" => [
      "Last time we talked about feelings. What is one feeling you remember from today?"
    ],
    "imagination" => [
      "Last time we talked about something you imagined. What would you add to that idea today?"
    ],
    "relationships" => [
      "Last time we talked about people in your world. What is something kind someone did recently?"
    ],
    "growth" => [
      "Last time we talked about trying or learning. What is something you want to try again?"
    ],
    "memory" => [
      "Thinking about a memory you saved before, what detail would you want to remember next?"
    ]
  }.freeze

  Result = Struct.new(:daily_question, :presented_prompt, :source_memory_response, keyword_init: true)

  def initialize(child_profile:, date: Date.current)
    @child_profile = child_profile
    @date = date
  end

  def result
    return unless eligible?

    source_memory = source_memory_response
    return if source_memory.blank?

    Result.new(
      daily_question: source_memory.daily_question,
      presented_prompt: template_for(source_memory),
      source_memory_response: source_memory
    )
  end

  private

  attr_reader :child_profile, :date

  def eligible?
    PersonalizedFollowUpEligibility.new(child_profile: child_profile, date: date).result.eligible?
  end

  def source_memory_response
    @source_memory_response ||= eligible_source_memories.to_a.find do |memory_response|
      template_for(memory_response).present?
    end
  end

  def eligible_source_memories
    child_profile.memory_responses
      .includes(:daily_question)
      .where(answered_on: lookback_range)
      .where.not(response_text: [ nil, "" ])
      .where.not(id: used_source_memory_response_ids)
      .order(answered_on: :desc, created_at: :desc, id: :desc)
  end

  def used_source_memory_response_ids
    @used_source_memory_response_ids ||= child_profile.daily_question_selections
      .where.not(source_memory_response_id: nil)
      .pluck(:source_memory_response_id)
  end

  def lookback_range
    (date - PersonalizedFollowUpEligibility::LOOKBACK_WINDOW_DAYS)..date
  end

  def template_for(memory_response)
    templates = TEMPLATES_BY_CATEGORY.fetch(memory_response.daily_question.category, [])
    return if templates.empty?

    templates[template_offset_for(memory_response, templates.length)]
  end

  def template_offset_for(memory_response, template_count)
    seed = child_profile.id.to_i + date.yday + date.year + memory_response.id.to_i
    seed % template_count
  end
end
