# frozen_string_literal: true

class CreateDailyQuestionSelections < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_question_selections do |t|
      t.references :child_profile, null: false, foreign_key: true
      t.references :daily_question, null: false, foreign_key: true
      t.date :selected_on, null: false

      t.timestamps
    end

    add_index :daily_question_selections,
      [ :child_profile_id, :selected_on ],
      unique: true,
      name: "index_daily_question_selections_on_child_and_selected_on"
    add_index :daily_question_selections,
      [ :child_profile_id, :daily_question_id, :selected_on ],
      name: "index_daily_question_selections_on_child_question_and_date"
  end
end
