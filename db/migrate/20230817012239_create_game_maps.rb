# frozen_string_literal: true

class CreateGameMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :game_maps, id: :uuid do |t|
      t.string :user_id, null: false
      t.string :name, null: false
      t.json :atlas, null: false, default: { version: '1', data: {
        floors: [],
        walls: []
      } }

      t.timestamps
    end

    add_index :game_maps, %i[user_id name], unique: true
    add_index :game_maps, :user_id
  end
end
