# frozen_string_literal: true

class MemoryResponse < ApplicationRecord
  belongs_to :child_profile
  belongs_to :daily_question

  validates :response_text, presence: true
  validates :answered_on, presence: true
  validate :daily_question_must_be_active

  private

  def daily_question_must_be_active
    return if daily_question.blank? || daily_question.active?

    errors.add(:daily_question, "must be active")
  end
end
