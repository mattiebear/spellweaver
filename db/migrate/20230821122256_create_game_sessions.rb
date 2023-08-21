# frozen_string_literal: true

class CreateGameSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :game_sessions, id: :uuid do |t|
      t.integer :status, default: 0
      t.string :name

      t.timestamps
    end
  end
end
