# frozen_string_literal: true

class AddPromptLibraryMetadataToDailyQuestions < ActiveRecord::Migration[8.1]
  class MigrationDailyQuestion < ActiveRecord::Base
    self.table_name = "daily_questions"
  end

  def change
    add_column :daily_questions, :slug, :string
    add_column :daily_questions, :category, :string
    add_column :daily_questions, :tags, :string, array: true, null: false, default: []
    add_column :daily_questions, :min_age_years, :integer
    add_column :daily_questions, :max_age_years, :integer
    add_column :daily_questions, :age_guidance, :text
    add_column :daily_questions, :internal_notes, :text

    reversible do |dir|
      dir.up do
        MigrationDailyQuestion.reset_column_information
        MigrationDailyQuestion.find_each do |question|
          question.update_columns(
            slug: unique_slug_for(question),
            category: "daily_life",
            updated_at: Time.current
          )
        end
      end
    end

    change_column_null :daily_questions, :slug, false
    change_column_null :daily_questions, :category, false
    add_index :daily_questions, :slug, unique: true
  end

  private

  def unique_slug_for(question)
    base_slug = question.prompt.to_s.parameterize.presence || "daily-question-#{question.id}"
    slug = base_slug
    suffix = 2

    while MigrationDailyQuestion.where(slug: slug).where.not(id: question.id).exists?
      slug = "#{base_slug}-#{suffix}"
      suffix += 1
    end

    slug
  end
end
