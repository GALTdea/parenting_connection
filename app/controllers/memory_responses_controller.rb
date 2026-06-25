# frozen_string_literal: true

class MemoryResponsesController < ApplicationController
  before_action :set_child_profile
  before_action :set_daily_questions, only: %i[new create]

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

  def memory_response_params
    params.expect(memory_response: [ :daily_question_id, :response_text, :answered_on ])
  end
end
