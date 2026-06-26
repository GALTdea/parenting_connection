# frozen_string_literal: true

class DailyQuestionSelection < ApplicationRecord
  SOURCE_TYPES = %w[
    curated
    adapted_curated
    personalized_follow_up
  ].freeze

  belongs_to :child_profile
  belongs_to :daily_question

  before_validation :default_source_type
  before_validation :snapshot_presented_prompt

  validates :selected_on, presence: true
  validates :source_type, presence: true, inclusion: { in: SOURCE_TYPES }
  validates :presented_prompt, presence: true
  validates :child_profile_id, uniqueness: { scope: :selected_on }
  validate :daily_question_must_be_active, on: :create

  private

  def default_source_type
    self.source_type = "curated" if source_type.blank?
  end

  def snapshot_presented_prompt
    return if presented_prompt.present?
    return if daily_question.blank?

    self.presented_prompt = daily_question.prompt
  end

  def daily_question_must_be_active
    return if daily_question.blank? || daily_question.active?

    errors.add(:daily_question, "must be active")
  end
end
