# frozen_string_literal: true

class CreateChildProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :child_profiles do |t|
      t.references :user, null: false, foreign_key: true, type: :integer
      t.string :name, null: false
      t.date :birthday, null: false

      t.timestamps
    end

    add_index :child_profiles, [ :user_id, :birthday ]
  end
end
