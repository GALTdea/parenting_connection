class AddQuestionQualityMetadataToDailyQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :daily_questions, :question_family, :string, null: false, default: "inner_world"
    add_column :daily_questions, :question_depth, :string, null: false, default: "light"
    add_column :daily_questions, :conversation_goal, :string, null: false, default: "storytelling"
    add_column :daily_questions, :review_status, :string, null: false, default: "approved"
    add_column :daily_questions, :quality_notes, :text
  end
end
