# frozen_string_literal: true

class MemoryResponsesController < ApplicationController
  before_action :set_child_profile

  def index
    authorize @child_profile, :show?
    @memory_responses = ordered_memory_responses
    @memory_responses_by_month = @memory_responses.group_by { |memory_response| memory_response.answered_on.beginning_of_month }
  end

  def show
    @memory_response = @child_profile.memory_responses.find(params.expect(:id))
    authorize @memory_response
  end

  def voice_recording
    @memory_response = @child_profile.memory_responses.find(params.expect(:id))
    authorize @memory_response, :show?

    return head :not_found unless @memory_response.voice_recording.attached?

    voice_recording = @memory_response.voice_recording

    response.headers["Cache-Control"] = "private, no-store"
    send_data voice_recording.download,
      filename: voice_recording.filename.to_s,
      type: voice_recording.content_type,
      disposition: "inline"
  end

  def new
    @selected_daily_question = selected_daily_question_from_param
    @daily_questions = daily_questions_for_form(@selected_daily_question)
    @memory_response = @child_profile.memory_responses.build(
      daily_question: @selected_daily_question,
      answered_on: Date.current
    )
    authorize @memory_response
  end

  def create
    @memory_response = @child_profile.memory_responses.build(memory_response_params)
    authorize @memory_response

    if @memory_response.save
      redirect_to @child_profile,
        notice: "Saved to #{@child_profile.name}'s memory archive. Come back tomorrow for another question."
    else
      @selected_daily_question = selected_daily_question_from_response
      @daily_questions = daily_questions_for_form(@selected_daily_question)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_child_profile
    @child_profile = policy_scope(ChildProfile).find(params.expect(:child_profile_id))
  end

  def selected_daily_question_from_param
    return if params[:daily_question_id].blank?

    active_daily_questions.find_by(id: params[:daily_question_id]) ||
      selected_question_for_date(Date.current, params[:daily_question_id])
  end

  def selected_daily_question_from_response
    active_daily_questions.find_by(id: @memory_response.daily_question_id) ||
      selected_question_for_date(@memory_response.answered_on, @memory_response.daily_question_id)
  end

  def selected_question_for_date(date, daily_question_id)
    return if date.blank? || daily_question_id.blank?

    selection = @child_profile.daily_question_selections
      .includes(:daily_question)
      .find_by(selected_on: date, daily_question_id: daily_question_id)
    selection&.daily_question
  end

  def daily_questions_for_form(selected_daily_question)
    questions = active_daily_questions.ordered.to_a
    return questions if selected_daily_question.blank? || questions.include?(selected_daily_question)

    [ selected_daily_question, *questions ]
  end

  def active_daily_questions
    DailyQuestion.active
  end

  def ordered_memory_responses
    @child_profile
      .memory_responses
      .with_attached_voice_recording
      .order(answered_on: :desc, created_at: :desc)
  end

  def memory_response_params
    params.expect(memory_response: [ :daily_question_id, :response_text, :answered_on, :voice_recording, :voice_recording_duration_seconds ])
  end
end
