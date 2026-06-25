# frozen_string_literal: true

class DailyQuestion < ApplicationRecord
  has_many :memory_responses, dependent: :restrict_with_exception

  validates :prompt, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true }, allow_nil: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :prompt) }
end
