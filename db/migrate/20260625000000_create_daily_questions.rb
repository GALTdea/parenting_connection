# frozen_string_literal: true

class CreateDailyQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_questions do |t|
      t.text :prompt, null: false
      t.boolean :active, null: false, default: true
      t.integer :position

      t.timestamps
    end

    add_index :daily_questions, :prompt, unique: true
    add_index :daily_questions, [ :active, :position ]
  end
end
