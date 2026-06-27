# frozen_string_literal: true

class DailyQuestionSelector
  RECENT_REPEAT_WINDOW_DAYS = 14

  def initialize(child_profile:, date: Date.current)
    @child_profile = child_profile
    @date = date
  end

  def question
    selection&.daily_question
  end

  def selection
    existing_selection || create_selection
  end

  private

  attr_reader :child_profile, :date

  def existing_selection
    @existing_selection ||= child_profile.daily_question_selections
      .includes(:daily_question)
      .find_by(selected_on: date)
  end

  def create_selection
    create_follow_up_selection || create_curated_selection
  end

  def create_follow_up_selection
    follow_up = CuratedFollowUpTemplateSelector.new(child_profile: child_profile, date: date).result
    return if follow_up.blank?

    DailyQuestionSelection.create!(
      child_profile: child_profile,
      daily_question: follow_up.daily_question,
      selected_on: date,
      source_type: "personalized_follow_up",
      presented_prompt: follow_up.presented_prompt,
      source_memory_response: follow_up.source_memory_response
    )
  rescue ActiveRecord::RecordNotUnique
    child_profile.daily_question_selections.find_by(selected_on: date)
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def create_curated_selection
    selected_question = question_for_new_selection
    return if selected_question.blank?

    DailyQuestionSelection.create!(
      child_profile: child_profile,
      daily_question: selected_question,
      selected_on: date
    )
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    child_profile.daily_question_selections.find_by(selected_on: date)
  end

  def question_for_new_selection
    question_from(age_eligible_questions_without_recent_repeats) ||
      question_from(age_eligible_questions) ||
      question_from(all_age_questions_without_recent_repeats) ||
      question_from(active_questions)
  end

  def question_from(scope)
    questions = scope.ordered.to_a
    return if questions.empty?

    questions[selection_offset_for(questions.length)]
  end

  def age_eligible_questions_without_recent_repeats
    without_recent_repeats(age_eligible_questions)
  end

  def all_age_questions_without_recent_repeats
    without_recent_repeats(all_age_questions)
  end

  def age_eligible_questions
    active_questions.age_eligible(child_profile.age_on(date))
  end

  def all_age_questions
    active_questions.where(min_age_years: nil, max_age_years: nil)
  end

  def active_questions
    DailyQuestion.active
  end

  def without_recent_repeats(scope)
    recent_ids = recent_daily_question_ids
    return scope if recent_ids.empty?

    scope.where.not(id: recent_ids)
  end

  def recent_daily_question_ids
    @recent_daily_question_ids ||= child_profile.daily_question_selections
      .where(selected_on: (date - RECENT_REPEAT_WINDOW_DAYS)...date)
      .order(selected_on: :desc, created_at: :desc)
      .limit(RECENT_REPEAT_WINDOW_DAYS)
      .pluck(:daily_question_id)
  end

  def selection_offset_for(question_count)
    seed = child_profile.id.to_i + date.yday + date.year
    seed % question_count
  end
end
