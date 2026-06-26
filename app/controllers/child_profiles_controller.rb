# frozen_string_literal: true

class ChildProfilesController < ApplicationController
  before_action :set_child_profile, only: %i[show edit update destroy]

  def index
    @child_profiles = policy_scope(ChildProfile).order(:birthday, :name)
    authorize ChildProfile
  end

  def show
    authorize @child_profile
    @todays_question = DailyQuestionSelector.new(child_profile: @child_profile).question
    @memory_responses = @child_profile
      .memory_responses
      .with_attached_voice_recording
      .order(answered_on: :desc, created_at: :desc)
      .limit(5)
  end

  def new
    @child_profile = current_user.child_profiles.build
    authorize @child_profile
  end

  def edit
    authorize @child_profile
  end

  def create
    @child_profile = current_user.child_profiles.build(child_profile_params)
    authorize @child_profile

    if @child_profile.save
      redirect_to @child_profile, notice: "#{@child_profile.name}'s memory archive is ready."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @child_profile

    if @child_profile.update(child_profile_params)
      redirect_to @child_profile, notice: "Child profile was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @child_profile
    @child_profile.destroy!

    redirect_to child_profiles_path, notice: "Child profile was removed.", status: :see_other
  end

  private

  def set_child_profile
    @child_profile = policy_scope(ChildProfile).find(params.expect(:id))
  end

  def child_profile_params
    params.expect(child_profile: [ :name, :birthday ])
  end
end
