# frozen_string_literal: true

class DailyQuestion < ApplicationRecord
  has_many :memory_responses, dependent: :restrict_with_exception
  has_many :daily_question_selections, dependent: :restrict_with_exception

  CATEGORIES = %w[
    daily_life
    feelings
    imagination
    relationships
    growth
    memory
  ].freeze

  TAGS = %w[
    quick
    bedtime
    after_school
    weekend
    gratitude
    wonder
    story
  ].freeze

  QUESTION_FAMILIES = %w[
    relationship_mirror
    inner_world
    imagination_doorway
    memory_preserving
    becoming
    silly_to_deep
  ].freeze

  QUESTION_DEPTHS = %w[
    light
    medium
    deep
  ].freeze

  CONVERSATION_GOALS = %w[
    storytelling
    memory
    laughter
    imagination
    connection
    reflection
    curiosity
    gratitude
    anticipation
  ].freeze

  REVIEW_STATUSES = %w[
    draft
    needs_revision
    approved
    rejected
    retired
  ].freeze

  validates :slug, presence: true, uniqueness: true
  validates :prompt, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :question_family, presence: true, inclusion: { in: QUESTION_FAMILIES }
  validates :question_depth, presence: true, inclusion: { in: QUESTION_DEPTHS }
  validates :conversation_goal, presence: true, inclusion: { in: CONVERSATION_GOALS }
  validates :review_status, presence: true, inclusion: { in: REVIEW_STATUSES }
  validates :position, numericality: { only_integer: true }, allow_nil: true
  validates :min_age_years,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    allow_nil: true
  validates :max_age_years,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    allow_nil: true
  validate :max_age_must_not_be_less_than_min_age
  validate :tags_must_be_allowed

  scope :active, -> { where(active: true) }
  scope :approved_for_selection, -> { active.where(review_status: "approved") }
  scope :ordered, -> { order(:position, :prompt) }

  def self.age_eligible(age_years)
    return where(min_age_years: nil, max_age_years: nil) if age_years.blank?

    where("min_age_years IS NULL OR min_age_years <= ?", age_years)
      .where("max_age_years IS NULL OR max_age_years >= ?", age_years)
  end

  def all_age?
    min_age_years.blank? && max_age_years.blank?
  end

  private

  def max_age_must_not_be_less_than_min_age
    return if min_age_years.blank? || max_age_years.blank?
    return if max_age_years >= min_age_years

    errors.add(:max_age_years, "must be greater than or equal to min age")
  end

  def tags_must_be_allowed
    invalid_tags = Array(tags).reject { |tag| TAGS.include?(tag) }
    return if invalid_tags.empty?

    errors.add(:tags, "include unsupported values: #{invalid_tags.join(', ')}")
  end
end
