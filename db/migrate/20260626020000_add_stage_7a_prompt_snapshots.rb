# frozen_string_literal: true

class AddStage7aPromptSnapshots < ActiveRecord::Migration[8.1]
  class MigrationDailyQuestion < ActiveRecord::Base
    self.table_name = "daily_questions"
  end

  class MigrationDailyQuestionSelection < ActiveRecord::Base
    self.table_name = "daily_question_selections"
  end

  class MigrationMemoryResponse < ActiveRecord::Base
    self.table_name = "memory_responses"
  end

  def change
    add_column :daily_question_selections, :source_type, :string, null: false, default: "curated"
    add_column :daily_question_selections, :presented_prompt, :text
    add_column :memory_responses, :prompt_snapshot, :text

    reversible do |dir|
      dir.up do
        backfill_selection_presented_prompts
        backfill_memory_prompt_snapshots
      end
    end

    change_column_null :daily_question_selections, :presented_prompt, false
    change_column_null :memory_responses, :prompt_snapshot, false

    add_index :daily_question_selections,
      [ :child_profile_id, :source_type, :selected_on ],
      name: "index_daily_question_selections_on_child_source_and_date"
  end

  private

  def backfill_selection_presented_prompts
    MigrationDailyQuestionSelection.reset_column_information

    MigrationDailyQuestionSelection.find_each do |selection|
      prompt = MigrationDailyQuestion.find(selection.daily_question_id).prompt
      selection.update_columns(presented_prompt: prompt)
    end
  end

  def backfill_memory_prompt_snapshots
    MigrationMemoryResponse.reset_column_information

    MigrationMemoryResponse.find_each do |memory_response|
      prompt = MigrationDailyQuestion.find(memory_response.daily_question_id).prompt
      memory_response.update_columns(prompt_snapshot: prompt)
    end
  end
end
