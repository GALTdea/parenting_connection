# frozen_string_literal: true

class DailyQuestionSelection < ApplicationRecord
  belongs_to :child_profile
  belongs_to :daily_question

  validates :selected_on, presence: true
  validates :child_profile_id, uniqueness: { scope: :selected_on }
  validate :daily_question_must_be_active, on: :create

  private

  def daily_question_must_be_active
    return if daily_question.blank? || daily_question.active?

    errors.add(:daily_question, "must be active")
  end
end
