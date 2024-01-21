# frozen_string_literal: true

class CreateGamePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :game_players, id: :uuid do |t|
      t.integer :role, default: 0
      t.references :session, null: false, foreign_key: { to_table: :game_sessions }, type: :uuid
      t.string :user_id, null: false

      t.timestamps
    end

    add_index :game_players, :user_id
  end
end
