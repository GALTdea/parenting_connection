require 'rails_helper'

RSpec.describe DailyQuestionSelection, type: :model do
  describe 'associations' do
    it 'belongs to a child profile' do
      expect(DailyQuestionSelection.reflect_on_association(:child_profile).macro).to eq(:belongs_to)
    end

    it 'belongs to a daily question' do
      expect(DailyQuestionSelection.reflect_on_association(:daily_question).macro).to eq(:belongs_to)
    end
  end

  describe 'validations' do
    it 'requires one selection per child and date' do
      child_profile = create(:child_profile)
      create(:daily_question_selection, child_profile: child_profile, selected_on: Date.new(2026, 6, 26))
      selection = build(:daily_question_selection, child_profile: child_profile, selected_on: Date.new(2026, 6, 26))

      expect(selection).not_to be_valid
      expect(selection.errors[:child_profile_id]).to include("has already been taken")
    end

    it 'requires an active question when the selection is created' do
      inactive_question = create(:daily_question, active: false)
      selection = build(:daily_question_selection, daily_question: inactive_question)

      expect(selection).not_to be_valid
      expect(selection.errors[:daily_question]).to include("must be active")
    end

    it 'remains valid if the selected question is retired later' do
      selection = create(:daily_question_selection)

      selection.daily_question.update!(active: false)

      expect(selection.reload).to be_valid
    end
  end
end
