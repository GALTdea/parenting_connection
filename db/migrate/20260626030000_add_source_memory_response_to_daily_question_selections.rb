# frozen_string_literal: true

class AddSourceMemoryResponseToDailyQuestionSelections < ActiveRecord::Migration[8.1]
  def change
    add_reference :daily_question_selections,
      :source_memory_response,
      foreign_key: { to_table: :memory_responses },
      index: true
  end
end
