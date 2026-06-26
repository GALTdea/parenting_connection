# frozen_string_literal: true

class MemoryResponse < ApplicationRecord
  MAX_VOICE_RECORDING_BYTES = 100.megabytes
  MAX_VOICE_RECORDING_DURATION_SECONDS = 15.minutes.to_i
  ALLOWED_VOICE_RECORDING_CONTENT_TYPES = %w[
    audio/webm
    audio/mp4
    audio/mpeg
    audio/wav
    audio/x-wav
  ].freeze

  attr_accessor :voice_recording_duration_seconds

  belongs_to :child_profile
  belongs_to :daily_question
  has_one_attached :voice_recording

  validates :answered_on, presence: true
  validate :response_text_or_voice_recording_present
  validate :daily_question_must_be_active
  validate :voice_recording_must_be_audio
  validate :voice_recording_must_be_within_size_limit
  validate :voice_recording_must_be_within_duration_limit

  private

  def response_text_or_voice_recording_present
    return if response_text.present? || voice_recording.attached?

    errors.add(:base, "Add a written response or a voice recording")
  end

  def daily_question_must_be_active
    return if daily_question.blank? || daily_question.active?
    return if selected_daily_question_for_answered_date?

    errors.add(:daily_question, "must be active")
  end

  def selected_daily_question_for_answered_date?
    return false if child_profile.blank? || answered_on.blank?

    child_profile.daily_question_selections.exists?(
      daily_question_id: daily_question_id,
      selected_on: answered_on
    )
  end

  def voice_recording_must_be_audio
    return unless voice_recording.attached?
    return if ALLOWED_VOICE_RECORDING_CONTENT_TYPES.include?(voice_recording.content_type)

    errors.add(:voice_recording, "must be an audio file")
  end

  def voice_recording_must_be_within_size_limit
    return unless voice_recording.attached?
    return if voice_recording.byte_size <= MAX_VOICE_RECORDING_BYTES

    errors.add(:voice_recording, "must be 100 MB or smaller")
  end

  def voice_recording_must_be_within_duration_limit
    return if voice_recording_duration_seconds.blank?
    return if voice_recording_duration_seconds.to_f <= MAX_VOICE_RECORDING_DURATION_SECONDS

    errors.add(:voice_recording, "must be 15 minutes or shorter")
  end
end
