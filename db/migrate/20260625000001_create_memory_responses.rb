# frozen_string_literal: true

class CreateMemoryResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :memory_responses do |t|
      t.references :child_profile, null: false, foreign_key: true
      t.references :daily_question, null: false, foreign_key: true
      t.text :response_text, null: false
      t.date :answered_on, null: false

      t.timestamps
    end

    add_index :memory_responses, [ :child_profile_id, :answered_on ]
  end
end
