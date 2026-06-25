# frozen_string_literal: true

class ChildProfile < ApplicationRecord
  belongs_to :user
  has_many :memory_responses, dependent: :destroy

  validates :name, presence: true
  validates :birthday, presence: true
  validate :birthday_cannot_be_in_the_future

  private

  def birthday_cannot_be_in_the_future
    return if birthday.blank? || birthday <= Date.current

    errors.add(:birthday, "can't be in the future")
  end
end
