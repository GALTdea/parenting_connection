# frozen_string_literal: true

class ChildProfile < ApplicationRecord
  belongs_to :user
  has_many :memory_responses, dependent: :destroy
  has_many :daily_question_selections, dependent: :destroy

  validates :name, presence: true
  validates :birthday, presence: true
  validate :birthday_cannot_be_in_the_future

  def age_on(date)
    return if birthday.blank?

    age = date.year - birthday.year
    birthday_this_year = Date.new(date.year, birthday.month, birthday.day)
    birthday_this_year > date ? age - 1 : age
  rescue Date::Error
    birthday_this_year = Date.new(date.year, birthday.month, birthday.day - 1)
    birthday_this_year > date ? age - 1 : age
  end

  private

  def birthday_cannot_be_in_the_future
    return if birthday.blank? || birthday <= Date.current

    errors.add(:birthday, "can't be in the future")
  end
end
