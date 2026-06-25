# frozen_string_literal: true

class MemoryResponsesController < ApplicationController
  before_action :set_child_profile
  before_action :set_daily_questions, only: %i[new create]

  def index
    authorize @child_profile, :show?
    @memory_responses = ordered_memory_responses
    @memory_responses_by_month = @memory_responses.group_by { |memory_response| memory_response.answered_on.beginning_of_month }
  end

  def show
    @memory_response = @child_profile.memory_responses.includes(:daily_question).find(params.expect(:id))
    authorize @memory_response
  end

  def new
    @memory_response = @child_profile.memory_responses.build(answered_on: Date.current)
    authorize @memory_response
  end

  def create
    @memory_response = @child_profile.memory_responses.build(memory_response_params)
    authorize @memory_response

    if @memory_response.save
      redirect_to @child_profile, notice: "Response was saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_child_profile
    @child_profile = policy_scope(ChildProfile).find(params.expect(:child_profile_id))
  end

  def set_daily_questions
    @daily_questions = DailyQuestion.active.ordered
  end

  def ordered_memory_responses
    @child_profile.memory_responses.includes(:daily_question).order(answered_on: :desc, created_at: :desc)
  end

  def memory_response_params
    params.expect(memory_response: [ :daily_question_id, :response_text, :answered_on ])
  end
end
