# frozen_string_literal: true

class AllowAudioOnlyMemoryResponses < ActiveRecord::Migration[8.1]
  def change
    change_column_null :memory_responses, :response_text, true
  end
end
