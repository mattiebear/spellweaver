# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players, id: :uuid do |t|
      t.integer :role, default: 0
      t.references :game_session, null: false, foreign_key: true, type: :uuid
      t.string :user_id, null: false

      t.timestamps
    end

    add_index :players, :user_id
  end
end
